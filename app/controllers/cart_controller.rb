class CartController < ApplicationController
  before_filter :products, only: [:index, :purchase_confirm]

  def index
  end

  def add_to_cart
    begin
     product = ShopifyAPI::Product.find(params[:product_id])
     product_id = product.id
     quantity = params[:quantity].to_i
     @cart[product_id] ? @cart[product_id] = @cart[product_id] + quantity : @cart[product_id] = quantity
     flash[:notice] = "#{product.title} was added to your shopping cart."
     render nothing: true, status: 200 and return
    rescue => e
     logger.error e
     flash[:alert] = "There was an error adding the product to your cart. Please try again"
     render nothing: true, status: 400 and return
    end
  end

  def remove_from_cart
    begin
      quantity_to_remove = params['quantity'].to_i
      product_id = params['product_id'].to_i
      product_quantity = @cart[product_id]
      quantity_to_remove >= product_quantity ? session['cart'].delete(product_id) : session['cart'][product_id] -= quantity_to_remove
      flash[:notice] = "Your shopping cart has been successfully updated."
      render nothing: true, status: 200 and return
    rescue => e
      logger.error e
      flash[:alert] = "There was an error removing the product from your cart. Please try again."
      render nothing: true, status: 400 and return
    end
  end

  def user_check
    if user_signed_in?
      if current_user.profile.nil?
        render text: "/profiles/#{current_user.id}" and return
      else
        shopify_checkout_response = Curl.get(params[:checkout_url])
        result = Curl::Easy.perform(params[:checkout_url]) do |curl|
          curl.headers["User-Agent"] = "..."
          curl.verbose = true
          curl.follow_location = true
        end
        session['cart_token'] = result.last_effective_url.split('/').flatten.last
        payment_request = Paypal::Payment::Request.new(
          :description   => 'Moonlight Garden Supply Purchase', # item description
          :quantity      => @cart.count, # item quantity
          :amount        => params[:total].gsub('$', '').strip
        )

        response = paypal_request.setup(
          payment_request,
          ENV['paypal_success_redirect'], # success redirect url
          ENV['paypal_error_redirect'], # error redirect url
        )
        render text: response.redirect_uri
      end
    else
      render text: '/users/sign_in' and return
    end
  end

  def purchase_confirm
    @token = params[:token]
    @payer_id = params[:PayerID]
    render(:purchase_confirm, layout: 'layouts/no_header')
  end

  def purchase_error
    flash[:alert] = "There was an error with your purchase. Please try again."
    redirect_to action: :index
  end

  def submit_purchase
    token = params[:paypal_token]
    begin
      details = paypal_request.details(token)
      payment_request = Paypal::Payment::Request.new(
        :description   => details.description,    # item description
        :quantity      => @cart.count,      # item quantity
        :amount        => details.amount.total)
      payment_response = paypal_request.checkout!(token, params[:paypal_payer_id], payment_request)

      if payment_response.ack == 'Success'
        items = []
        total_weight = 0
        @cart.each do |product_id, qty|
          product = ShopifyAPI::Product.find(product_id)
          variant = product.variants.first
          items << {variant_id: variant.id, quantity: qty}
          total_weight += variant.grams
        end
        customer = ShopifyAPI::Customer.find(current_user.shopify_customer_id)
        shipping_address = {address1: current_user.profile[:street_address], city: current_user.profile[:city],
                                        country: 'united states', company: current_user.profile[:company], zip: current_user.profile[:zip],
                                        phone: current_user.profile[:preferred_phone], province: current_user.profile[:state], first_name: customer.first_name,
                                        last_name: customer.last_name}
        shopify_order = ShopifyAPI::Order.create(cart_token: session['cart_token'], line_items: items, customer: customer,
                                                                         send_receipt: true, send_fulfillment_receipt: true, email: current_user.email,
                                                                         shipping_address: shipping_address, total_weight: total_weight)
        if shopify_order.persisted?
          session[:cart] = {}
          flash[:notice] = "Your order was submitted successfully! Please check your email."
          redirect_to controller: :order, action: :index and return
        else
          logger.error shopify_order.errors
          raise 'order not persisted due to errors.'
        end
      else
        flash[:alert] = "Your purchase was not successful. Please try again."
        redirect_to action: :index and return
      end
    rescue => e
      logger.error e
      flash[:alert] = "Your purchase was not successful. Please try again."
      redirect_to action: :index and return
    end
  end

  private

  def paypal_request
    @paypal_request ||= Paypal::Express::Request.new(
                                       :username   => ENV['paypal_username'],
                                       :password   => ENV['paypal_password'],
                                       :signature  => ENV['paypal_signature'])
  end

  def products
    @products = []
    @total = 0.0
    @cart.each do |product_id, quantity|
      product = ShopifyAPI::Product.find(product_id)
      @products << product
      @total += (product.variants.first.price.to_f * quantity)
    end
  end
end

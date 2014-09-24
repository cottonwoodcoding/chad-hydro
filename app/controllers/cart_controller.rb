class CartController < ApplicationController

  def index
    @products = []
    @total = 0.0
    @cart.each do |product_id, quantity|
      product = ShopifyAPI::Product.find(product_id)
      @products << product
      @total += (product.variants.first.price.to_f * quantity)
    end
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
      quantity_to_remove = params['quantity'].to_i.
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

  def purchase_confirm
    @token = params[:token]
    @payer_id = params[:PayerID]
    @details = paypal_request.details(@token)
    @track_info = Hash.new{ |key, value| key[value] = [] }
    session['purchasing'].each do |track_info, _|
      info = track_info.split('~')
      @track_info[info.first] << info.last
    end
  end

  def purchase_error
    flash[:error] = "There was an error with your purchase. Please try again."
    redirect_to action: :index
  end

  def submit_purchase
    token = params[:paypal_token]
    begin
      details = paypal_request.details(token)
      payment_request = Paypal::Payment::Request.new(
        :description   => details.description,    # item description
        :quantity      => 1,      # item quantity
        :amount        => details.amount.total)
      payment_response = paypal_request.checkout!(token, params[:paypal_payer_id], payment_request)

      session["purchasing"].merge!({email: params['email']})
      if payment_response.ack == 'Success'
        Curl.post("http://#{ENV['DIGITAL_OCEAN_IP']}:3001/music/create_download_file", session['purchasing'])
      end
    rescue => e
      logger.error e
      flash[:error] = "Your purchase was not successful. Please try again."
      redirect_to action: :index and return
    end
    flash[:notice] = 'Your purchase was successful! Please check your email.'
    redirect_to action: :index
  end

  private

  def paypal_request
    @paypal_request ||= Paypal::Express::Request.new(
                                       :username   => ENV['paypal_username'],
                                       :password   => ENV['paypal_password'],
                                       :signature  => ENV['paypal_signature'])
  end
end

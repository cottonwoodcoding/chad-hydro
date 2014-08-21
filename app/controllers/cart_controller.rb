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
    if user_signed_in?
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
    else
      flash[:alert] = 'You must be signed in to do that!'
      render text: '/users/sign_in', status: 401 and return
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
end

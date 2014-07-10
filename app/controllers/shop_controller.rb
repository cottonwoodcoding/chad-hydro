class ShopController < ApplicationController
  respond_to :html

  def index
    @products = ShopifyAPI::Product.all
    respond_with @products do |format|
        format.html { render :layout => false }
      end
  end

end

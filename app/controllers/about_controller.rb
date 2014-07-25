class AboutController < ApplicationController
  respond_to :html

  def index
    @featured_products = ShopifyAPI::CustomCollection.where(handle: 'featured-products').first.products
    respond_with do |format|
        format.html { render :layout => false }
      end
  end

end

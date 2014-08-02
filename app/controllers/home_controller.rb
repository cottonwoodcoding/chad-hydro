class HomeController < ApplicationController
  respond_to :html

  def index
    @featured_products = ShopifyAPI::CustomCollection.where(handle: 'featured-products').first.products
  end

end

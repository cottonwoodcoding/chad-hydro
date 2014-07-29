class ShopController < ApplicationController
  respond_to :html
  before_action :products_and_categories

  def index
    respond_with @products do |format|
        format.html { render :layout => false }
      end
  end

  def sort_by_category
    category = params[:category]
    products = @products
    products = @products.map{ |product| product if product.product_type == params[:category] }.compact unless category == 'All'
    render(partial: 'product_slide', locals: { products: products}) and return
  end

  private

  def products_and_categories
    @categories = Hash.new{|hash, key| hash[key] = Array.new}
    @products = ShopifyAPI::Product.all
    @products.map{|product| @categories[product.product_type] << product}
  end

end

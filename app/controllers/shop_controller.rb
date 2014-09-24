class ShopController < ApplicationController
  respond_to :html
  before_filter :all_products_and_categories

  def index
    @category = 'All'
  end

  def product
    @product = ShopifyAPI::Product.find(params[:product_id])
  end

  def product_reviews
    @product = ShopifyAPI::Product.find(params[:product_id])
    #TODO: figure out how to get reviews maybe roll our own?
  end

  def sort_by_category
    @category = params[:category_type]
    @products = @category ==  'all' ?  @products : ShopifyAPI::Product.paginate(per: 150, page: params[:page] || 1, params: {product_type: @category})
    render :index
  end

  def search_by_title
    search_term = params[:search_term]
    if search_term.blank?
      @category = 'All'
      @products = ShopifyAPI::Product.paginate(per: 150, page: params[:page] || 1)
    else
      @products = ShopifyAPI::Product.paginate(per: 150, page: params[:page] || 1, params: {title: "%#{search_term.titleize}%"})
      @category = search_term
    end
    render :index
  end

  private

  def all_products_and_categories
    @products = ShopifyAPI::Product.paginate per: 150, page: params[:page] || 1
    @categories = ProductCategory.all
  end

end

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
  end

  def sort_by_category
    @category = params[:category_type]
    @products = @category ==  'all' ?  @products : ShopifyAPI::Product.paginate(per: PER_PAGE, page: params[:page], params: {product_type: @category})
    @product_sub_categories = ProductCategory.find_by(category: @category).product_sub_categories.all
    render :index
  end

  def sort_by_sub_category
    @sub_category = params[:sub_category]
    @category = params[:category_type]
    # TODO: make it so we don't hard code vendor here and can sort by other properties on the object
    @products = ShopifyAPI::Product.paginate(per: PER_PAGE, page: params[:page], params: {product_type: @category, vendor: @sub_category})
    @product_sub_categories = ProductCategory.find_by(category: @category).product_sub_categories.all
    render :index
  end

  def search_by_title
    search_term = params[:search_term]
    if search_term.blank?
      @category = 'All'
    else
      @products = ShopifyAPI::Product.paginate(per: PER_PAGE, page: params[:page], params: {title: "%#{search_term.titleize}%"})
      @category = search_term
    end
    render :index
  end

  private

  def all_products_and_categories
    @products = ShopifyAPI::Product.paginate(per: PER_PAGE, page: params[:page])
    @categories = ProductCategory.all.sort_by { |c| c.category }
  end

end

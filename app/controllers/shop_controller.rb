class ShopController < ApplicationController
  respond_to :html
  before_filter :all_products_and_categories

  def index
    @category = 'All'
  end

  def product
    @reviews = Review.where(product_id: params[:product_id])
    @product = ShopifyAPI::Product.find(params[:product_id])
  end

  def product_reviews
    @product = ShopifyAPI::Product.find(params[:product_id])
  end

  def sort_by_category
    @category = params[:category_type]
    if @category != 'all'
      @products = ShopifyAPI::Product.paginate(per: PER_PAGE, page: params[:page], params: {product_type: @category})
      @product_sub_categories = ProductCategory.find_by(category: @category).product_sub_categories.all.sort_by {|pc| pc.name }
    end
    render :index
  end

  def sort_by_sub_category
    @sub_category = params[:sub_category]
    @category = params[:category_type]
    # TODO: make it so we don't hard code vendor here and can sort by other properties on the object
    @products = ShopifyAPI::Product.paginate(per: PER_PAGE, page: params[:page], params: {product_type: @category, vendor: @sub_category})
    @product_sub_categories = ProductCategory.find_by(category: @category).product_sub_categories.all.sort_by {|pc| pc.name }
    render :index
  end

  def search_by_title
    search_term = params[:search_term]
    if search_term.blank?
      @category = 'All'
    else
      @products = products_by_title_or_vendor(search_term, params[:page])
      @category = search_term
    end
    if @products.count == 0 && params[:page] != 1
      @products = products_by_title_or_vendor(search_term, 1)
    end
    render :index
  end

  private

  def products_by_title_or_vendor(search_term, page)
    products = ShopifyAPI::Product.paginate(per: PER_PAGE, page: page, params: {title: "%#{search_term.titleize}%"})
    if products.count == 0
      products = ShopifyAPI::Product.paginate(per: PER_PAGE, page: page, params: {vendor: "#{search_term.titleize}"})
    end
    products
  end

  def all_products_and_categories
    @products = ShopifyAPI::Product.paginate(per: PER_PAGE, page: params[:page])
    @categories = ProductCategory.all.sort_by { |c| c.category }
  end

end

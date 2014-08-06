class ShopController < ApplicationController
  respond_to :html
  before_filter :all_products_and_categories
  before_filter :create_thumbnails, only: [:index]

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
    @products = @category ==  'all' ?  @products : ShopifyAPI::Product.where(product_type: @category)
    render('index')
  end

  private

  def all_products_and_categories
    @products = ShopifyAPI::Product.all
    @categories = Hash.new{|hash, key| hash[key] = Array.new}
    @products.map{ |product| @categories[product.product_type] << product }
  end

  def create_thumbnails
    @products.each do |product|
      path = "#{Rails.root}/app/assets/images/#{product.id}-thumb.jpg"
      next if File.exists?(path)
      image = Magick::Image.read(product.images.first.src)
      image.first.thumbnail(200, 200).write(path)
    end
  end

end

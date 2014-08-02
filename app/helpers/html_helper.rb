module HtmlHelper

  def product_url(product_id)
    "/shop/product/#{product_id}"
  end

  def image_thumb(product_id)
    image_path("#{product_id}-thumb.jpg")
  end
end
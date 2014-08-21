module HtmlHelper

  def product_url(product_id)
    "/shop/product/#{product_id}"
  end

  def image_thumb(product_id)
    image_path("#{product_id}-thumb.jpg")
  end

  def phone_number_formatted(number)
    number_to_phone(number, area_code: true, country_code: 1, delimiter: "-")
  end
end
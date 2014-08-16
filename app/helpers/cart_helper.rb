module CartHelper

  def shopping_cart_count
    count = @cart.values.inject(:+)
    count = 0 if count.blank?
    count
  end

  def perma_link_append
    cart_for_url = {}
    variant_ids = @cart.each do |key, value|
      variant_id = ShopifyAPI::Product.find(key).variants.first.id
      cart_for_url[variant_id] = value
    end
    cart_for_url.map{|k,v| "#{k}:#{v}"}.join(',')
  end
end

module CartHelper

  def shopping_cart_count
    count = @cart.values.inject(:+)
    count = 0 if count.blank?
    count
  end

  def perma_link_append
    @cart.map{|k,v| "#{k}:#{v}"}.join(',')
  end
end

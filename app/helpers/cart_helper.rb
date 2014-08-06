module CartHelper

  def shopping_cart_count
    count = @cart.values.inject(:+)
    count = 0 if count.blank?
    count
  end
end

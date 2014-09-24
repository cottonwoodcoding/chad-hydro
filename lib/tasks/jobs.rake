namespace :jobs do
  desc "Run this to generate all product categories"
  task generate_categories: :environment do
    1..300.times do |num|
      num = num + 1
      begin
        products = ShopifyAPI::Product.paginate(per: 150, page: num)
        raise 'no more products' if products.count == 0
        products.each { |product| ProductCategory.find_or_create_by(category: product.product_type) }
      rescue => e
        puts "Error - #{e}"
        break
        next
      end
    end
  end
end

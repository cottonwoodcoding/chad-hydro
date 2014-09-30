namespace :jobs do

  desc "Run this to generate all product categories"
  task generate_categories: :environment do
    num = 1
    while true
      num = num + 1
      products = ShopifyAPI::Product.paginate(per: 150, page: num)
      break if products.count == 0
      products.each { |product| ProductCategory.find_or_create_by(category: product.product_type) }
    end
  end

  desc "Run this to delete all shopify products"
  task delete_shopify_products: :environment do
    num = 0
    while true
      num = num + 1
      products = ShopifyAPI::Product.paginate(per: 150, page: num)
      break if products.count == 0
      products.each do |product|
        sleep 1
        product.destroy
        puts "#{product.title} deleted"
      end
    end
  end

  desc "Run this to generate all sub categories ('vendors')"
  task sub_categories: :environment do
    num = 0
    while true
      begin
        num = num + 1
        products = ShopifyAPI::Product.paginate(per: 150, page: num)
        break if products.count == 0
        products.each do |product|
          product_category = ProductCategory.find_by(category: product.product_type)
          product_sub_category = ProductSubCategory.find_or_create_by(name: product.vendor)
          unless product_category.product_sub_categories.include?(product_sub_category)
            product_category.product_sub_categories << product_sub_category
            puts "#{product.vendor} was successfully added as a sub category for #{product_category.category}"
          end
        end
      rescue => e
        puts "error happened while adding sub categories - #{e}"
        next
      end
    end
  end

  desc "Run this to generate all setup data"
  task setup: :environment do
    # Generate Shop Categories
    Rake::Task['jobs:generate_categories'].execute
    Rake::Task['jobs:sub_categories'].execute
    # Default Settings
    ['general-checkout-enabled', 'general-about-us', 'general-toll-free-number', 'general-local-number', 'general-street-address', 'general-city', 'general-zip', 'general-state', 'business-monday-start', 'business-monday-end', 'business-tuesday-start', 'business-tuesday-end', 'business-wednesday-start', 'business-wednesday-end', 'business-thursday-start', 'business-thursday-end', 'business-friday-start', 'business-friday-end', 'business-saturday-start', 'business-saturday-end', 'business-sunday-start', 'business-sunday-end', 'media-facebook-social', 'media-instagram-social', 'media-twitter-social', 'media-youtube-social'].each do |setting|
      begin
        case setting
          when 'general-checkout-enabled'
            Setting.create!(name: setting, value: 'false')
          when 'general-about-us'
            Setting.create!(name: setting, value: "Moonlight Garden Supply is Utah's premier Organic & Hydroponic garden supply store. We are committed to providing the best products and knowledge the Organic & Hydroponic industry has to offer. From beginner to expert we have everything you need to keep your indoor garden thriving. We believe everyone should have access to clean healthy produce year round regardless of your climate. Our expert staff can take the hassle out of designing your indoor garden space to ensure maximum yields. We have licensed, insured Contractors in-house that can build your grow space out start to finish. Making make your path to healthy sustainable produce as painless as possible. Moonlight Garden Supply ships discreetly within the US and Canada.")
          when 'general-toll-free-number'
            Setting.create!(name: setting, value: '800-888-8888')
          when 'general-local-number'
            Setting.create!(name: setting, value: '801-793-9587')
          when 'general-street-address'
            Setting.create!(name: setting, value: '1530 S. State Street')
          when 'general-city'
            Setting.create!(name: setting, value: 'Salt Lake City')
          when 'general-zip'
            Setting.create!(name: setting, value: '84115')
          when 'general-state'
            Setting.create!(name: setting, value: 'UT')
          when 'business-monday-start', 'business-tuesday-start', 'business-wednesday-start', 'business-thursday-start', 'business-friday-start', 'business-saturday-start'
            Setting.create!(name: setting, value: '10:00am')
          when 'business-monday-end', 'business-tuesday-end', 'business-wednesday-end', 'business-thursday-end', 'business-friday-end', 'business-saturday-end'
            Setting.create!(name: setting, value: '7:00pm')
          when 'business-sunday-start', 'business-sunday-end'
            Setting.create!(name: setting, value: 'closed')
          when 'media-facebook-social'
            Setting.create!(name: setting, value: 'http://www.facebook.com/moonlightgardensupply')
          when 'media-instagram-social'
            Setting.create!(name: setting, value: 'none')
          when 'media-twitter-social'
            Setting.create!(name: setting, value: 'http://twitter.com/mgardensupply')
          when 'media-youtube-social'
            Setting.create!(name: setting, value: 'none')
        end
      rescue
        next
      end
    end
  end
end

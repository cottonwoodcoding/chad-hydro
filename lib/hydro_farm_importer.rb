require 'pry'
require 'json'
require 'shopify_api'

# Setup Shopify API Access
shopify_username = ARGV[0]
shopify_password = ARGV[1]
shop_url = "https://#{shopify_username}:#{shopify_password}@moonlight-garden-supply.myshopify.com/admin"
ShopifyAPI::Base.site = shop_url

# Parse Hydrofarm JSON Datasheet
hydro_farm_data = JSON.parse(File.read('/Users/jake/Desktop/stuff/Moonlight/hydrofarm-product-datasheet.json'))

# Add Items To Shopify
hydro_farm_data.each do |item|
  shopify_product = ShopifyAPI::Product.new
  title = item['DESCRIPTION']
  shopify_product.title = title
  shopify_product.handle = title
  shopify_product.body_html = title
  shopify_product.product_type = item['CATEGORY']
  shopify_product.vendor = item['BRAND']

  product_image = ShopifyAPI::Image.new
  product_image.product_id = shopify_product.id
  product_image.src = "https://cdn.shopify.com/s/files/1/0628/6473/files/#{item['IMG_FILENAME']}"
  product_image.position = '1'
  shopify_product.images = [product_image]

  product_variant = ShopifyAPI::Variant.new
  product_variant.barcode = item['EACH_BARCODE']
  product_variant.grams = item['EACH_WEIGHT'].to_f
  product_variant.price = item['SRP'].to_f
  product_variant.product_id = shopify_product.id
  product_variant.requires_shipping = true
  product_variant.taxable = true
  product_variant.image_id = product_image.id
  product_variant.inventory_policy = 'continue'
  shopify_product.variants = [product_variant]

  shopify_product.save
  puts shopify_product.persisted? ? "PRODUCT WITH TITLE: #{title} SUCCESSFULLY SAVED" : "PRODUCT WITH TITLE: #{title} ERROR - #{shopify_product.errors.to_a.join(',')}"
end
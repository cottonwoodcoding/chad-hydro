if Rails.env == 'development'
  begin
    CONFIG = YAML.load_file('config/shopify_config.yml')
    api_key = CONFIG['api_key']
    password = CONFIG['password']
    shop_name = CONFIG['shop_name']
  rescue
    raise 'Shopify config not found. Please copy config/shopify_config.yml.example and modify it'
  end
else
  api_key = ENV['shopify_api_key']
  password = ENV['shopify_password']
  shop_name = ENV['shopify_shop_name']
end

shop_url = "https://#{api_key}:#{password}@#{shop_name}.myshopify.com/admin"
ShopifyAPI::Base.site = shop_url

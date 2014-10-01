source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.4'
gem 'bootstrap-sass', '~> 3.2.0'
gem 'sass-rails', '~> 4.0.2'
gem 'haml-rails'
gem 'autoprefixer-rails'
gem 'uglifier', '>= 1.3.0'
gem 'shopify_api'
gem 'kaminari'
gem 'shopify-kaminari'
gem "font-awesome-rails"
gem 'rmagick'
gem 'devise'
gem 'underscore-rails'
gem 'gmaps4rails'
gem 'tinymce-rails'
gem 'geocoder'
gem 'protected_attributes'
gem 'sendgrid'
gem 'paypal-express'
gem 'curb'
gem 'carmen-rails', '~> 1.0.0'
gem 'biggs'
gem 'alchemist'
gem 'rack-cache'
gem 'dalli'
gem 'kgio'
gem "memcachier"
gem 'raty_ratings'

# Makes running your Rails app easier. Based on the ideas behind 12factor.net
gem 'rails_12factor'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

ruby '2.0.0'

group :production do
  gem 'pg'
  gem 'heroku-deflater'
  gem 'unicorn'
end

group :development, :test do
   gem 'thin'
   gem 'rspec-rails', '~> 3.0.0'
   gem 'debugger'
   gem 'pry'
   gem 'sqlite3'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

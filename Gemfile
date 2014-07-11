source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.4'
gem 'bootstrap-sass', '~> 3.2.0'
gem 'sass-rails', '~> 4.0.2'
gem 'haml-rails'
gem 'autoprefixer-rails'
gem 'uglifier', '>= 1.3.0'
gem 'shopify_api'
gem "font-awesome-rails"

# Makes running your Rails app easier. Based on the ideas behind 12factor.net
gem 'rails_12factor'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

ruby '2.0.0'

group :production do
  gem 'pg'
  gem 'unicorn'
end

group :development, :test do
   gem 'rspec-rails', '~> 3.0.0'
   gem 'debugger'
   gem 'pry'
   gem 'sqlite3'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

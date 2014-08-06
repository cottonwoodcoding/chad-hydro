ChadHydro::Application.routes.draw do
  devise_for :users
  root 'about#index'

  get '/about', to: 'about#index'
  get '/blog', to: 'blog#index'
  get '/contact', to: 'contacts#index'
  get '/shop', to: 'shop#index'
  get '/shop/category/:category_type', to: 'shop#sort_by_category'
  get '/shop/product/:product_id', to: 'shop#product'
  get '/shop/product/:product_id/reviews', to: 'shop#product_reviews'

  post '/submit_request', to: 'contacts#submit_request'
end

ChadHydro::Application.routes.draw do
  root 'about#index'

  get '/about', to: 'about#index'
  get '/blog', to: 'blog#index'
  get '/contact', to: 'contacts#index'
  get '/shop', to: 'shop#index'
  get '/shop/category/:category_type', to: 'shop#sort_by_category'
  get '/shop/product/:product_id', to: 'shop#product'

  post '/submit_request', to: 'contacts#submit_request'
end

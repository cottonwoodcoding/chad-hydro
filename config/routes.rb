ChadHydro::Application.routes.draw do
  resources :profiles

  devise_for :users, :controllers => { :registrations => "registrations" }
  root 'about#index'

  get '/about', to: 'about#index'
  get '/blog', to: 'blog#index'
  get '/contact', to: 'contacts#index'
  get '/shop', to: 'shop#index'
  get '/shop/category/:category_type', to: 'shop#sort_by_category'
  get '/shop/product/:product_id', to: 'shop#product'
  get '/shop/product/:product_id/reviews', to: 'shop#product_reviews'
  get '/shop/search', to: 'shop#search_by_title'
  get '/cart', to: 'cart#index'
  get '/blog/new', to: 'blog#new'
  get '/blog/main_article', to: 'blog#main_article'
  get '/blog/update_comments'
  get '/blog/approve'
  get '/blog/edit', to: 'blog#edit'
  get '/admin_settings', to: 'admin#settings'
  get '/newsletter', to: 'admin#newsletter'

  post '/blog/update', to: 'blog#update'
  post '/blog/create', to: 'blog#create'
  post '/submit_request', to: 'contacts#submit_request'
  post '/add_to_cart/:product_id/:quantity', to: 'cart#add_to_cart'
  post '/remove_from_cart/:product_id/:quantity', to: 'cart#remove_from_cart'
  post '/blog/new_comment', to: 'blog#new_comment'
  post '/blog/process_comments', to: 'blog#process_comments'
  post '/blog/delete_comment', to: 'blog#delete_comment'
  post '/blog/delete_article', to: 'blog#delete_article'
  post '/blog/reset_article_id', to: 'blog#reset_article_id'
  post '/save_settings', to: 'admin#save_settings'
  post '/send_newsletter', to: 'admin#send_newsletter'
end

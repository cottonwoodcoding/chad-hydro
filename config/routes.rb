ChadHydro::Application.routes.draw do
  root 'home#index'

  get '/about', to: 'about#index'
  get '/blog', to: 'blog#index'
  get '/contact', to: 'contacts#index'
  get '/shop', to: 'shop#index'
  get '/sort_by_category', to: 'shop#sort_by_category'

  post '/submit_request', to: 'contacts#submit_request'
end

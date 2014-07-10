ChadHydro::Application.routes.draw do
  root 'home#index'

  get '/contact', to: 'contacts#index'
  get '/shop', to: 'shop#index'
  post '/submit_request', to: 'contacts#submit_request'
end

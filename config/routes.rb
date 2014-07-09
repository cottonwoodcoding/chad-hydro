ChadHydro::Application.routes.draw do
  root 'home#index'

  get '/contact', to: 'contacts#index'
  post '/submit_request', to: 'contacts#submit_request'
end

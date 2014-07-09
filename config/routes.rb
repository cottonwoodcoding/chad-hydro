ChadHydro::Application.routes.draw do
  root 'home#index'
  resources :contacts

  get '/contact', to: 'contacts#index'
end

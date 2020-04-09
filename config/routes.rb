Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :v1 do
    post '/authenticate', to: 'authentication#authenticate'
    get '/entry_point', to: 'entry_point#index'

    resources :genres
    resources :users
    resources :artists
    resources :events, only: [:create, :destroy]
  end
end

Rails.application.routes.draw do
  
  resource :session, only: %i(create destroy)
  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post]

  resources :movies, only: %i(new create destroy) do
    resource :vote, only: %i(create destroy)
  end

  resources :users, only: %i() do
    resources :movies, only: %(index), controller: 'movies'
  end

  root 'movies#index'
end

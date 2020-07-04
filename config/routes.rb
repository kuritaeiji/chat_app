Rails.application.routes.draw do
  root 'home#index'
  get 'users/new', to: 'home#index'
  namespace :api do
    resources :users, only: [:create]
  end
end

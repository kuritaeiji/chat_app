Rails.application.routes.draw do
  root 'home#index'
  get 'login', to: 'home#index'
  get 'users/new', to: 'home#index'
  
  namespace :api do
    resources :cookies, only: [:create, :destroy]
    resources :users, only: [:create, :destroy]
  end
end

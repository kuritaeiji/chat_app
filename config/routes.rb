Rails.application.routes.draw do
  root 'home#index'
  get 'login', to: 'home#index'
  get 'users/new', to: 'home#index'
  
  namespace :api do
    resources :cookies, only: [:create, :destroy]
    resources :users, only: [:create, :destroy, :show]
  end

  resources :account_activations, only: [:new]
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end

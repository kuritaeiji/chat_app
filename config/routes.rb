Rails.application.routes.draw do
  root 'home#index'
  get '/login', to: 'home#index'
  get '/users/new', to: 'home#index'
  get '/settings', to: 'home#index'
  get '/users/search', to: 'home#index'
  get '/users/edit', to: 'home#index'
  
  namespace :api do
    resources :cookies, only: [:create, :destroy]
    resources :users, only: [:create, :destroy, :show] do
      resources :friendships, only: [:index, :create] do
        collection do
          get :users_applying_for_friends_to_me
          get :users_count_applying_for_friends_to_me
          get :friends
          put :approve
          delete :destroy_friend
        end
      end
    end
  end

  resources :account_activations, only: [:new]
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end

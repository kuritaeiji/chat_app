Rails.application.routes.draw do
  root 'home#index'
  get '/login', to: 'home#index'
  get '/users/new', to: 'home#index'
  get '/settings', to: 'home#index'
  get '/settings/users/search', to: 'home#index'
  get '/settings/users/edit', to: 'home#index'
  get '/settings/users/show', to: 'home#index'
  get '/settings/groups/new', to: 'home#index'
  get '/settings/groups/edit/:groupId', to: 'home#index'
  get '/groups', to: 'home#index'
  get '/groups/:groupId', to: 'home#index'
  
  namespace :api do
    resources :cookies, only: [:create, :destroy]
    resources :users, only: [:create, :destroy, :show, :update] do
      collection do
        get :search
      end
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
    resources :groups, only: [:index, :show, :create, :update, :destroy] do
      member do
        delete :leave_the_group
        get :friends_and_members
      end
      resources :messages, only: [:index, :create] do
        collection do
          get :return_new_messages
          get :return_older_messages
        end
      end
    end
    resources :messages do
      collection do
        get :return_unread_messages_count
      end
    end
  end

  resources :account_activations, only: [:new]
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end

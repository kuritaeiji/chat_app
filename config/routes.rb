Rails.application.routes.draw do
  root 'home#index'
  get '/users/new', to: 'home#index'
end

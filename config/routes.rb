require 'sidekiq/web'

Rails.application.routes.draw do
  get '/' => 'home#index'
  get '/users' => 'user#index'
  resources :user
  #match '/users/:id' => 'user#destroy', :via => :delete
  get '/fragments' => 'fragment#index'
  get '/auth' => 'home#create'

  # auth google+
  get '/auth/failure', to: 'session#auth_failure'
  get '/auth/:provider/callback', to: 'session#create'
  delete '/logout', to: 'session#destroy', as: :logout



  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount Sidekiq::Web => '/sidekiq'
end

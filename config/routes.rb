require 'sidekiq/web'

Rails.application.routes.draw do
  get '/' => 'home#index'
  get '/users' => 'user#index'
  get '/fragments' => 'fragment#index'

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount Sidekiq::Web => '/sidekiq'
end

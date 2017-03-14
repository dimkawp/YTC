require 'sidekiq/web'

Rails.application.routes.draw do
  get '/' => 'home#index'
  get '/users' => 'user#index'
  resources :user
  resources :fragment
  resources :video_uploads, only: [:index, :new, :create]
  #match '/users/:id' => 'user#destroy', :via => :delete
  get '/fragments' => 'fragment#index'
  get '/auth' => 'home#create'

  get '/video_uploads/:id/new' => 'video_uploads#new'
  post '/video_uploads/:id' => 'video_uploads#create'

  post '/video_info' => 'fragment#video_info'

  post '/fragment/download' => 'fragment#download'
  post 'cloudinary' => 'fragment#cloudinary'

  #post '/downloader' => 'fragment#downloader'

  # post '/offset', to: 'session#offset'
  # delete '/offset_logout', to: 'session#offset_logout', as: :offset_logout

  # auth google+


  get '/auth/failure', to: 'session#auth_failure'
  get '/auth/:provider/callback', to: 'session#create'
  delete '/logout', to: 'session#destroy', as: :logout



  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount Sidekiq::Web => '/sidekiq'
end

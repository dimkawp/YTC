require 'sidekiq/web'
require 'sidekiq-status/web'

Rails.application.routes.draw do
  get '/' => 'home#index'
  get '/users' => 'user#index'
  get '/fragments' => 'fragment#index'
  get '/auth' => 'home#create'
  get '/video_uploads/:id/new' => 'video_uploads#new'
  get '/auth/failure', to: 'session#auth_failure'
  get '/auth/:provider/callback', to: 'session#create'
  post '/video_uploads/:id' => 'video_uploads#create'
  post '/video_info' => 'fragment#video_info'
  post '/cloud_video_info' => 'fragment#video_from_cloud'
  post '/check_status_job' => 'fragment#check_status_job'
  post '/fragment/download' => 'fragment#download'
  post 'cloudinary' => 'fragment#cloudinary'
  delete '/logout', to: 'session#destroy', as: :logout

  resources :user
  resources :fragment
  resources :video_uploads, only: [:index, :new, :create]

  root 'home#index'

  mount Api::API => '/api'
  mount Sidekiq::Web => '/sidekiq'
  mount GrapeSwaggerRails::Engine => '/swagger'
end

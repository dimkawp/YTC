require 'sidekiq/web'
require 'sidekiq-status/web'

Rails.application.routes.draw do
  root 'home#index'

  get '/' => 'home#index'

  mount Api::API => '/api'
  mount Sidekiq::Web => '/sidekiq'
  mount GrapeSwaggerRails::Engine => '/swagger'

  mount_devise_token_auth_for 'User', at: '/api/auth'

  as :user do
    # Define routes for User within this block.
  end
end

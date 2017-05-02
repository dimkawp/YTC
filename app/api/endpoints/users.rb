module Endpoints
  class Users < Grape::API
    namespace :users do
      # get users
      get '', jbuilder: 'users' do
        @users = User.all
      end

      # get user
      params do
        requires :id, type: Integer, desc: 'ID'
      end

      get ':id', jbuilder: 'user' do
        @user = User.find(params[:id])
      end

      params do
        requires :user_id, type: String, desc: 'User ID'
      end

      post 'profile', jbuilder: 'profile' do
        @my_fragments = Fragment.where(user_id: params[:user_id])
      end
    end
  end
end

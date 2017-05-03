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
        requires :id, type: Integer, desc: 'ID'
      end

      get ':id/fragments', jbuilder: 'fragments' do
        user = User.find(params[:id])

        @fragments = user.fragments
      end
    end
  end
end

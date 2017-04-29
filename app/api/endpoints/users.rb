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
    end

    params do
      requires :user_id, type: String, desc: 'User ID'
    end

    post 'user/profile', jbuilder: 'profile' do
      user_id = params[:user_id]
      @my_fragments = Fragment.where(user_id: user_id)

    end
  end
end

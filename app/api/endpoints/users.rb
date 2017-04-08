module Endpoints
  class Users < Grape::API
    get 'users', jbuilder: 'users' do
      @users = User.all
    end

    get 'users/me' do
      User.last
    end
  end
end

module Endpoints
  class Users < Grape::API
    get 'users', jbuilder: 'users' do
      @users = User.all
    end
  end
end

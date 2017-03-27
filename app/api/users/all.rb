module Users
  class All < Grape::API
    format :json
    formatter :json, Grape::Formatter::Jbuilder

    get 'users', jbuilder: 'users' do
      @users = User.all
    end
  end
end

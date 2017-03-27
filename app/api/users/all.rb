module Users
  class All < Grape::API
    format :json
    formatter :json, Grape::Formatter::Jbuilder
    #resource :users do
     # desc "List all Users"

      get 'users', jbuilder: 'users.jbuilder' do
        @users = User.all

      #end

    end

  end
end
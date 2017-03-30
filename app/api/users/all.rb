module Users
  class All < Grape::API

    resource :users_all do
      desc "List all Employee"

      get do
        User.all
      end

    end

  end
end
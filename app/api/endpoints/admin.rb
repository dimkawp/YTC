module Endpoints
  class Admin < Grape::API
    namespace :admin do
      # get admin
      params do
        requires :token, type: String, desc: 'Token'
      end

      post '/secret' do
        if check_admin(params[:token]) === true
          {
           users: User.all.order(id: :asc),
           fragments: Fragment.all
          }
        else
          {error: 'error'}
        end
      end
    end
  end
end

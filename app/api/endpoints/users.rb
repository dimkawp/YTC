module Endpoints
  class Users < Grape::API
    namespace :users do
      # get user fragments
      params do
        requires :id, type: Integer, desc: 'ID'
      end

      get ':id/fragments', jbuilder: 'fragments' do
        user = User.find(params[:id])

        @fragments = user.fragments.where(status: 'uploaded')
                                   .order(id: :desc)
      end
    end
  end
end

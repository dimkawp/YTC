module Fragments
  class All < Grape::API
    format :json
    formatter :json, Grape::Formatter::Jbuilder

    #resource :fragments do
    #  desc "List all Fragments"

      get 'fragments', jbuilder: 'fragments.jbuilder' do
        @fragments = Fragment.all

     # end

    end

  end
end
module Fragments
  class All < Grape::API
    format :json
    formatter :json, Grape::Formatter::Jbuilder

    get 'fragments', jbuilder: 'fragments' do
      @fragments = Fragment.all
    end
  end
end

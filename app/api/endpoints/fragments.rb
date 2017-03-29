module Endpoints
  class Fragments < Grape::API
    get 'fragments', jbuilder: 'fragments' do
      @fragments = Fragment.all
    end
  end
end

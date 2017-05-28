require 'spec_helper'
require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /fragments' do

    it 'all fragments with status uploads' do

      get '1/fragments'

    end


  end
  # it 'return user fragments with status uploaded' do
  #
  #   get ':id/fragments', params: {id: 1}
  #   user = User.find(params[:id])
  #
  #   @fragments = user.fragments.where(status: 'uploaded')
  #
  #   expect(User.ordered_by_last_status).to eq([uploaded])
  #
  #   end
end


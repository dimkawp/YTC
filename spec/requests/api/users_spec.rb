require 'spec_helper'
require 'rails_helper'

describe 'User Fragments', type: :request do
  it 'return user fragments with status uploaded' do

    get ':id/fragments', params: {id: 1}
    user = User.find(params[:id])

    @fragments = user.fragments.where(status: 'uploaded')

    expect(User.ordered_by_last_status).to eq([uploaded])

    end
end


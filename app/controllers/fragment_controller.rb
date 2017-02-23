class FragmentController < ApplicationController
  def index
    @fragments = Fragment.all
  end
end

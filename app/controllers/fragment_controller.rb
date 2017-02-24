class FragmentController < ApplicationController
  def index
    @fragments = Fragment.all

    respond_to do |format|
      format.html
      format.json { render :json => @fragments }
    end
  end
end

class HomeController < ApplicationController
  def index
    flash[:success] = "HELLO WORLD!"
    flash[:error] = "HELLO WORLD!"
  end

  def create
    auth_hash = request.env['omniauth.auth']

    render json: auth_hash
  end
end

class HomeController < ApplicationController
  def create
    auth_hash = request.env['omniauth.auth']

    render json: auth_hash
  end
end

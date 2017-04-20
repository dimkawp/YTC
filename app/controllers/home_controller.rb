class HomeController < ApplicationController
  def index

  end

  def token
    render json: request.env['omniauth.auth']
  end
end

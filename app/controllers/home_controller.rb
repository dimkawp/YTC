class HomeController < ApplicationController
  def index

  end

  def create
    auth_hash = request.env['omniauth.auth']
    render json: auth_hash
    #render :text => request.env['omniauth.auth'].to_yaml
  end
end

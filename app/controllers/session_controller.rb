class SessionController < ApplicationController
  def create
    user = User.from_omniauth(request.env['omniauth.auth'])
    session[:user_id] = user.id

    flash[:success] = "Welcome, #{user.first_name}"

    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

  def auth_failure
    redirect_to root_path
  end
end

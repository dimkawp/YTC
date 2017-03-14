class UserController < ApplicationController
  def index
    @users = User.all

    respond_to do |format|
      format.html
      format.json { render :json => @users }
    end
  end

  def show
    @user = User.find(params[:id])
    @user_profile = Fragment.where(user_id: session[:user_id])
    respond_to do |format|
      format.html
      format.json { render :json => @user_profile }
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
  end
end

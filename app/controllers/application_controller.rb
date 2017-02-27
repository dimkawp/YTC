class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionHelper

  #private

  # def current_user
  #   @_current_user ||= session[:current_user_id] &&
  #   User.find_by(id: session[:current_user_id])
  # end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  helper_method :current_user
end

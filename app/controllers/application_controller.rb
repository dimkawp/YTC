class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionHelper

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def offset
    @start_offset = session[:start]
    @start_end = session[:end]
  end

  helper_method :current_user, :offset
end

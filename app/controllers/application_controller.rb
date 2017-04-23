class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  include DeviseTokenAuth::Concerns::SetUserByToken
end

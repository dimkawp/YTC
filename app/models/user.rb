class User < ActiveRecord::Base
  class << self
    def from_omniauth(auth)
      #@auth = request.env["omniauth.auth"]
      user = User.find_or_create_by(email: auth['info']['email'])
      user.first_name = auth['info']['first_name']
      user.last_name = auth['info']['last_name']
      user.email = auth['info']['email']
      user.save!
      user
    end
  end
end


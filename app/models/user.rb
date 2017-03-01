class User < ActiveRecord::Base
  class << self
    def from_omniauth(auth)
      #@auth = request.env["omniauth.auth"]
      user = User.find_or_initialize_by(email: auth['info']['email'])
      if auth[:provider] == 'twitter'
        user = User.find_or_initialize_by(email: auth['info']['urls']['Twitter'])
        user.first_name = auth['info']['nickname']
        user.last_name = auth['info']['name']
        user.email = auth['info']['urls']['Twitter']
      else
        user.first_name = auth['info']['first_name']
        user.last_name = auth['info']['last_name']
        user.email = auth['info']['email']
      end
      user.save!
      user
    end
  end
end


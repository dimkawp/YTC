class OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
  def omniauth_success
    super do |resource|
      resource.access_token = auth_hash['credentials']['token']
      resource.access_expires_at = auth_hash['credentials']['expires_at']
      resource.save

      @omniauth_success_block_called = true
    end
  end

  def omniauth_success_block_called?
    @omniauth_success_block_called == true
  end
end

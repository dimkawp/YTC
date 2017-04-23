class OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
  def omniauth_success
    super do |resource|
      resource.token = auth_hash['credentials']['token']
      resource.save

      @omniauth_success_block_called = true
    end
  end

  def omniauth_success_block_called?
    @omniauth_success_block_called == true
  end
end

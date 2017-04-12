class UploaderWorker
  include Sidekiq::Worker

  def perform(title, description, cloud_uri)
    token = 'ya29.GlwoBJeAvw6K8j6Xh2LpPrWiwQtrLiSszDVkQLCejf4ggkcF20hU1wGl4zFv29OOIRPX8BxVbXC5DQ-eUZ_xCexEpNWHiIQ_N2q7WsZCTzgR-DdZO7fGxxIvEoz8cg'

    account = Yt::Account.new access_token: token
    account.upload_video cloud_uri, title: title, description: description
  end
end

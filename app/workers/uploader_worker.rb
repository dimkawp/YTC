class UploaderWorker
  include Sidekiq::Worker

  def perform(title, description, cloud_uri)
    token = 'ya29.GlwpBFbZu21ohXWic4XZWS-o4dsfOuxJdsPl8-FtlUjVU24OTVpcMENDQQwOzvU6wBmtJoNwPKygPLrQhsGPyyEyJndLnXCsEF4SmkHQ1dtP7476XKvdMcUWc2LyNg'

    account = Yt::Account.new access_token: token
    account.upload_video cloud_uri, title: title, description: description
  end
end

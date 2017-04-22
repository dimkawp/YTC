class UploaderWorker
  include Sidekiq::Worker

  def perform(id,token,title,description,cloud_url,start,i_end)
    fragment = Fragment.find(id)
    cloud_url
    start
    i_end
    url = "http://res.cloudinary.com/comedy/video/upload/eo_#{i_end},so_#{start}#{cloud_url}"

    account = Yt::Account.new access_token: token
    @respond = account.upload_video url, title: title, description: description
    new_url = "https://www.youtube.com/watch?v=#{@respond.id}"
    fragment.url = new_url
    fragment.save
  end
end

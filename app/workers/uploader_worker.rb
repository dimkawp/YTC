class UploaderWorker
  include Sidekiq::Worker

  def perform(id,token,cloud_url)
    fragment = Fragment.find(id)
    cloud_url
    start = fragment.start
    i_end = fragment.end
    url = "http://res.cloudinary.com/comedy/video/upload/eo_#{i_end},so_#{start}#{cloud_url}"

    account = Yt::Account.new access_token: token
    @respond = account.upload_video url, title: fragment.title, description: fragment.description
    new_url = "https://www.youtube.com/watch?v=#{@respond.id}"
    fragment.url = new_url
    fragment.save
  end
end

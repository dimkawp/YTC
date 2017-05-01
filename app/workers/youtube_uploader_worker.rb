class YoutubeUploaderWorker
  include Sidekiq::Worker

  def perform(id)
    fragment = Fragment.find(id)

    account = Yt::Account.new access_token: fragment.user.access_token

    url = "http://res.cloudinary.com/comedy/video/upload/so_#{fragment.start_from},eo_#{fragment.end_from}/v#{fragment.video.cloudinary['version']}/#{fragment.video.cloudinary['public_id']}.#{fragment.video.cloudinary['format']}"

    @youtube = account.upload_video url, title: fragment.title,
                                         description: fragment.description

    fragment.url    = "https://www.youtube.com/watch?v=#{@youtube.id}"
    fragment.status = 'uploaded'
    fragment.save
  end
end

class YoutubeUploaderWorker
  include Sidekiq::Worker

  def perform(id)
    fragment = Fragment.find(id)

    if fragment.user.access_expires_at > Time.now.to_i
      account = Yt::Account.new access_token: fragment.user.access_token

      url = "http://res.cloudinary.com/comedy/video/upload/so_#{fragment.start_from},eo_#{fragment.end_from}/v#{fragment.video.cloudinary['version']}/#{fragment.video.cloudinary['public_id']}.#{fragment.video.cloudinary['format']}"

      @youtube = account.upload_video url, title: fragment.title,
                                           description: fragment.description

      fragment.url    = "https://www.youtube.com/watch?v=#{@youtube.id}"
      fragment.status = 'uploaded'

      NewFragmentMailer.create_new_fragment_email(fragment).deliver

    else
      fragment.status = 'error'
      fragment.error  = 'Your session has expired. Please re-login.'
    end

    fragment.save
  end
end

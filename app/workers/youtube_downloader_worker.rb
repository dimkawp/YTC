class YoutubeDownloaderWorker
  include Sidekiq::Worker

  def perform(id)
    video = Video.find(id)

    begin
      @cloudinary = Cloudinary::Api.resource(video.v, :resource_type => :video)

      video.cloudinary = @cloudinary
      video.status     = 'uploaded'
    rescue CloudinaryException
      file = "tmp/video/#{video.v}.mp4"

      YoutubeDL.download "https://www.youtube.com/watch?v=#{video.v}", output: file, 'max-filesize': '40m'

      if File.exists?(file)
        video.status = 'downloaded'
      else
        video.status = 'error'
        video.error  = 'An error has occurred. Please try again or choose another video.'
      end
    end

    video.save
  end
end

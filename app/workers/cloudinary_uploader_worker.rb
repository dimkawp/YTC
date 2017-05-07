class CloudinaryUploaderWorker
  include Sidekiq::Worker

  def perform(id)
    video = Video.find(id)

    begin
      Cloudinary::Api.resource(video.v, :resource_type => :video)

      video.status = 'uploaded'
    rescue CloudinaryException
      file = "tmp/video/#{video.v}.mp4"

      if File.exists?(file)
        @cloudinary = Cloudinary::Uploader.upload(file, :resource_type => :video, :public_id => "#{video.v}")

        video.cloudinary = @cloudinary
        video.status     = 'uploaded'

        File.delete(file)
      else
        video.status = 'error'
        video.error  = 'An error has occurred. Please try again or choose another video.'
      end
    end

    video.save
  end
end

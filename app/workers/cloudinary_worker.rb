class CloudinaryWorker
  include Sidekiq::Worker

  def perform(url)

    begin
      video = Cloudinary::Api.resource(url, :resource_type => :video)
    rescue CloudinaryException
      Cloudinary::Uploader.upload("video/#{url}.mp4", :resource_type => :video, :public_id => "#{url}")
    else

    end

  end
end

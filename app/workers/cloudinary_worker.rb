class CloudinaryWorker
  include Sidekiq::Worker

  def perform(url)
    
    Cloudinary::Uploader.upload("video/#{url}.mp4", :resource_type => :video, :public_id => "#{url}")

  end
end

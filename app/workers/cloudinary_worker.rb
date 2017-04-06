class CloudinaryWorker
  include Sidekiq::Worker

  def perform(id)
    fragment = Fragment.find(id)
    url = fragment.url
    url = url[32..url.size]
    begin
      video = Cloudinary::Api.resource(url, :resource_type => :video)
    rescue CloudinaryException
      Cloudinary::Uploader.upload("tmp/video/#{url}.mp4", :resource_type => :video, :public_id => "#{url}")
    end
  end
end

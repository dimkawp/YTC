class CloudinaryWorker
  include Sidekiq::Worker

  def perform(id)
    fragment = Fragment.find(id)
    url = fragment.url
    url = URI.parse(url)
    respond = CGI.parse(url.query)
    video_id = respond['v'].first

    begin
      video = Cloudinary::Api.resource(video_id, :resource_type => :video)
      fragment.status = 'cloud'
      fragment.save
    rescue CloudinaryException
      Cloudinary::Uploader.upload("tmp/video/#{video_id}.mp4", :resource_type => :video, :public_id => "#{video_id}")
      # File.delete("tmp/video/#{video_id}.mp4")
    end

  end
end

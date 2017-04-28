class CloudinaryWorker
  include Sidekiq::Worker

  def perform(id)
    fragment = Fragment.find(id)
    url = fragment.url
    url = URI.parse(url)
    respond = CGI.parse(url.query)
    video_id = respond['v'].first

    video = Cloudinary::Uploader.upload("tmp/video/#{video_id}.mp4", :resource_type => :video, :public_id => "#{video_id}")

    fragment.cloud_url = video['secure_url']
    fragment.status = 'upload_on_cloud'
    fragment.save
  end
end

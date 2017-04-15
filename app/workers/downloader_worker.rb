class DownloaderWorker
  include Sidekiq::Worker

  def perform(id)
    fragment = Fragment.find(id)

    begin
      Cloudinary::Api.resource(fragment.video_id, :resource_type => :video)

      # fragment.status = 'cloud'
      # fragment.save

    rescue CloudinaryException
      YoutubeDL.download "https://www.youtube.com/watch?v=#{fragment.video_id}", output: "tmp/video/#{fragment.video_id}.mp4" , 'max-filesize': '40m'

      fragment.status = 'downloaded'
      fragment.save
    end
  end
end

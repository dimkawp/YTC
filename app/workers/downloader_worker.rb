class DownloaderWorker
  include Sidekiq::Worker

  def perform(id)
    fragment = Fragment.find(id)

      YoutubeDL.download "https://www.youtube.com/watch?v=#{fragment.video_id}", output: "tmp/video/#{fragment.video_id}.mp4" , 'max-filesize': '40m'
      fragment.status = 'downloaded'
      fragment.save

  end
end

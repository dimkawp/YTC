class DownloadWorker
  include Sidekiq::Worker


  def perform(id)

    fragment = Fragment.find(id)
    url = fragment.url
    url = url[32..url.size]

    link = 'https://www.youtube.com/watch?v='

    YoutubeDL.download "#{link}#{url}", output: "tmp/video/#{url}.mp4", 'max-filesize': '40m'
    
  end
end

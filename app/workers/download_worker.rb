class DownloadWorker
  include Sidekiq::Worker

  def perform(id)
    fragment = Fragment.find(id)
    url = fragment.url
    url = URI.parse(url)
    respond = CGI.parse(url.query)
    video_id = respond['v'].first

    link = 'https://www.youtube.com/watch?v='

    YoutubeDL.download "#{link}#{video_id}", output: "tmp/video/#{video_id}.mp4", 'max-filesize': '40m'
  end
end

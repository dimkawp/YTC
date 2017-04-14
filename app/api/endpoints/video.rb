module Endpoints
  class Video < Grape::API
    params do
      requires :url, type: String, desc: 'Youtube URL'
    end

    post 'video/info' do
      url = URI.parse(params[:url])
      data = CGI.parse(url.query)

      video_id = data['v'].first

      @video = Yt::Video.new id: video_id

      [video_id: @video.id, end: @video.duration, title: @video.title, description: @video.description].first
    end

    params do
      requires :url, type: String, desc: 'Youtube URL'
      optional :start, type: Integer, desc: 'Start'
      optional :end, type: Integer, desc: 'End'
    end

    post 'video/embed_url' do
      url = URI.parse(params[:url])
      data = CGI.parse(url.query)

      video_id = data['v'].first

      "https://www.youtube.com/embed/#{video_id}?start=#{params[:start]}&end=#{params[:end]}&autoplay=1"
    end

    params do
      requires :id, type: Integer, desc: 'Fragment ID'
    end

    post 'video/download' do
      # fragment = Fragment.find(params[:id])

      # YoutubeDL.download "https://www.youtube.com/watch?v=#{fragment.video_id}546546", output: "tmp/video/#{fragment.video_id}.mp4" #, 'max-filesize': '40m'
      #
      # fragment.status = '222';
      # fragment.save

      DownloaderWorker.perform_async(params[:id])
    end

    # params do
    #   requires :url, type: String, desc: 'url'
    # end
    #
    # post 'fragments/download/url' do
    #   url = params[:url]
    #   url = URI.parse(url)
    #   respond = CGI.parse(url.query)
    #   video_id = respond['v'].first
    #
    #   job_id = DownloaderWorker.perform_async(video_id)
    # end
  end
end

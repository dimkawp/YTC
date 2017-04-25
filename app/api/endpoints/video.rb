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
  end
end

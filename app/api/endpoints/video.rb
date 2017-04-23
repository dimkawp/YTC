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

    post 'video/download/id' do
      fragment = Fragment.find(params[:id])

      begin
        video = Cloudinary::Api.resource(fragment.video_id, :resource_type => :video)
        fragment.status = 'video_on_cloud'
        fragment.cloud_url = video['secure_url']
        fragment.save
        video
      rescue CloudinaryException
        job_id = DownloaderWorker.perform_async(params[:id])
        fragment.status = job_id
        fragment.save
        job_id
      end
    end

    params do
      requires :user_id, type: Integer, desc: 'User ID'
    end

    post 'video/download' do
      begin
        user_id = params[:user_id]
        fragment = Fragment.where(user_id: user_id).last

        video = Cloudinary::Api.resource(fragment.video_id, :resource_type => :video)

        fragment.status = 'video_on_cloud'
        fragment.cloud_url = video['secure_url']
        fragment.save
      rescue CloudinaryException
        job_id = DownloaderWorker.perform_async(fragment.id)
        fragment.status = job_id
        fragment.save
        job_id
      end
    end
  end
end

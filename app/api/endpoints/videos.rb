module Endpoints
  class Videos < Grape::API
    namespace :videos do
      # create video
      params do
        requires :url, type: String, desc: 'Youtube URL' , regexp: /(www.youtube.com)/
      end

      post '', jbuilder: 'video' do
        v = get_v(params[:url])

        @video = Video.find_or_create_by(v: v) do |video|
          @video = Yt::Video.new id: video.v

          video.url         = params[:url]
          video.title       = @video.title
          video.duration    = @video.duration
          video.description = @video.description
          video.status      = 'new'
        end
      end

      # download video from YouTube
      params do
        requires :id, type: Integer, desc: 'ID'
      end

      get ':id/download' do
        video = Video.find(params[:id])

        video.status = 'downloading'
        video.save

        job_id = YoutubeDownloaderWorker.perform_async(video.id)

        {job_id: job_id}
      end

      # upload video on Cloudinary
      params do
        requires :id, type: Integer, desc: 'ID'
      end

      get ':id/upload' do
        video = Video.find(params[:id])

        video.status = 'uploading'
        video.save

        job_id = CloudinaryUploaderWorker.perform_async(video.id)

        {job_id: job_id}
      end

      # get video status
      params do
        requires :id, type: Integer, desc: 'ID'
        requires :job_id, type: String, desc: 'Job ID'
      end

      post ':id/status' do
        video = Video.find(params[:id])

        status = Sidekiq::Status::status(params[:job_id])

        if status.to_s == 'failed' || status.to_s == 'interrupted'
          video.status = 'error'
          video.error  = 'An error has occurred. Please try again or choose another video.'
          video.save
        end

        {status: video.status}
      end

      # get video error
      params do
        requires :id, type: Integer, desc: 'ID'
      end

      get ':id/error' do
        video = Video.find(params[:id])

        {error: video.error}
      end

      # get video embed url
      params do
        requires :id, type: Integer, desc: 'ID'
        optional :start_from, type: Integer, desc: 'Start From'
        optional :end_from, type: Integer, desc: 'End From'
      end

      post ':id/embed_url' do
        video = Video::find(params[:id])

        v = get_v(video.url)

        {embed_url: "https://www.youtube.com/embed/#{v}?start=#{params[:start_from]}&end=#{params[:end_from]}&autoplay=1"}
      end
    end
  end
end

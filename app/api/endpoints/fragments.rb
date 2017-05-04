module Endpoints
  class Fragments < Grape::API
    namespace :fragments do
      # get fragment status
      params do
        requires :id, type: Integer, desc: 'ID'
        requires :job_id, type: String, desc: 'Job ID'
      end

      post ':id/status' do
        fragment = Fragment.find(params[:id])

        status = Sidekiq::Status::status(params[:job_id])

        if status.to_s == 'failed' || status.to_s == 'interrupted'
          video.status = 'error'
          video.error  = 'An error has occurred. Please try again or choose another video.'
          video.save
        end

        {status: fragment.status}
      end

      # get fragment error
      params do
        requires :id, type: Integer, desc: 'ID'
      end

      get ':id/error' do
        fragment = Fragment.find(params[:id])

        {error: fragment.error}
      end

      # get fragment url
      params do
        requires :id, type: Integer, desc: 'Fragment ID'
      end

      get ':id/url' do
        fragment = Fragment.find(params[:id])

        {url: fragment.url}
      end

      # get fragment embed url
      params do
        requires :id, type: Integer, desc: 'ID'
      end

      get ':id/embed_url' do
        fragment = Fragment.find(params[:id])

        v = get_v(fragment.url)

        {embed_url: "https://www.youtube.com/embed/#{v}?autoplay=0"}
      end

      # upload fragment on YouTube
      params do
        requires :id, type: Integer, desc: 'ID'
      end

      get ':id/upload' do
        fragment = Fragment.find(params[:id])

        fragment.status = 'uploading'
        fragment.save

        job_id = YoutubeUploaderWorker.perform_async(fragment.id)

        {job_id: job_id}
      end

      # create fragment
      params do
        requires :user_id, type: Integer, desc: 'User ID'
        requires :video_id, type: Integer, desc: 'Video ID'
        requires :title, type: String, desc: 'Title'
        requires :start_from, type: Integer, desc: 'Start From'
        requires :end_from, type: Integer, desc: 'End From'
        optional :description, type: String, desc: 'Description'
      end

      post '', jbuilder: 'fragment' do
        user  = User.find(params[:user_id])
        video = Video.find(params[:video_id])

        @fragment = Fragment.create user_id: user.id,
                                    video_id: video.id,
                                    title: params[:title],
                                    start_from: params[:start_from],
                                    end_from: params[:end_from],
                                    description: params[:description],
                                    status: 'new'
      end

      # delete fragment
      params do
        requires :id, type: Integer, desc: 'ID'
      end

      delete ':id' do
        fragment = Fragment.find(params[:id])

        fragment.delete
      end
    end
  end
end

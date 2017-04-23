module Endpoints
  class Fragments < Grape::API
    get 'fragments', jbuilder: 'fragments' do
      @fragments = Fragment.all
    end

    get 'fragments/:id' do
        @fragments = Fragment.find(params[:id])
    end

    params do
      requires :user_id, type: String, desc: 'User ID'
    end

    post 'fragments/resources' do
      user_id = params[:user_id]
      fragment = Fragment.where(user_id: user_id).last
      url = fragment.url
      url = URI.parse(url)
      respond = CGI.parse(url.query)
      video_id = respond['v'].first

      video_from_cloud = Cloudinary::Api.resources_by_ids(video_id, :resource_type => :video)
      video_params = video_from_cloud['resources'].last
      fragment.cloud_url = video_params['secure_url']
      fragment.save
      video_params
    end

    params do
      requires :user_id, type: String, desc: 'User ID'
    end

    post 'fragments/status' do
      user_id = params[:user_id]
      fragment = Fragment.where(user_id: user_id).last
      fragment.status
    end

    params do
      requires :user_id, type: String, desc: 'User ID'
    end

    post 'fragments/delete_video_file' do
      user_id = params[:user_id]
      fragment = Fragment.where(user_id: user_id).last
      url = fragment.url
      url = URI.parse(url)
      respond = CGI.parse(url.query)
      video_id = respond['v'].first
      begin
        File.delete("tmp/video/#{video_id}.mp4")
      rescue ActiveRecord::RecordNotFound
        error!({status: :error, message: :not_found}, 404)
      end
    end

    params do
      requires :id, type: String, desc: 'Job ID'
    end

    post 'fragments/global/status' do
      all_stats = Sidekiq::Status::get_all params[:id]
      status = all_stats['status']
      status
    end

    params do
      requires :id, type: String, desc: 'Fragment ID'
    end

    post 'fragments/status/id' do
      fragment = Fragment.find(params[:id])
      fragment.status
    end

    params do
      requires :user_id, type: String, desc: 'User ID'
      requires :url, type: String, desc: 'URL'
      requires :start, type: Integer, desc: 'Start'
      requires :end, type: Integer, desc: 'End'
      requires :title, type: String, desc: 'Title'
      optional :description, type: String, desc: 'Description'
      optional :video_id, type: String, desc: 'Video ID'
      optional :status, type: String, desc: 'status'
    end

    post 'fragments' do
      user_id = params[:user_id]

      url = params[:url]
      url = URI.parse(url)
      respond = CGI.parse(url.query)
      video_id = respond['v'].first

      Fragment.create({user_id: user_id,
                       video_id: video_id,
                       url: params[:url],
                       start: params[:start],
                       end: params[:end],
                       title: params[:title],
                       description: params[:description],
                       status: params[:status]})
    end

    params do
      requires :id, type: Integer, desc: 'id'
    end

    delete 'fragments/delete/:id' do
      begin
        fragment = Fragment.find(params[:id])
        {
            status: :success
        } if fragment.delete
      rescue ActiveRecord::RecordNotFound
        error!({status: :error, message: :not_found}, 404)
      end
    end

    params do
      requires :user_id, type: Integer, desc: 'user_id'
    end

    delete 'fragments/delete_all' do
    end

    params do
      requires :video_id, type: String, desc: 'video_id'
    end

    post 'fragments/cloud_checker' do
      Cloudinary::Api.resource(params[:video_id], :resource_type => :video)
    end

    params do
      requires :user_id, type: String, desc: 'User ID'
    end

    post 'fragments/uploaded_on_cloudinary' do
      user_id = params[:user_id]
      fragment = Fragment.where(user_id: user_id).last

      begin
        video = Cloudinary::Api.resource(fragment.video_id, :resource_type => :video)

        fragment.status = 'video_on_cloud'
        fragment.cloud_url = video['secure_url']
        fragment.save
      rescue CloudinaryException
        job_id = CloudinaryWorker.perform_async(fragment.id)
        fragment.status = job_id
        fragment.save
      end
    end

    params do
      requires :user_id, type: String, desc: 'User ID'
    end

    post 'fragments/uploaded_video_on_youtube' do
      user_id = params[:user_id]
      user = User.find(user_id)
      token = user.token
      fragment = Fragment.where(user_id: user_id).last

      cloud_url = fragment.cloud_url

      url = URI.parse(cloud_url)
      respond = CGI.parse(url.path).first
      url = respond.first
      url = url[20..url.size]
      cloud_url = url

      UploaderWorker.perform_async(fragment.id, token, cloud_url)
    end

    params do
      requires :id, type: String, desc: 'Fragment ID'
    end

    post 'status_job' do
      fragment = Fragment.find(params[:id])
      job_id = fragment.status
      all_stats = Sidekiq::Status::get_all job_id

      if job_id == 'downloaded' || job_id == 'upload_on_cloud'
        status = 'complete'
      else
        status = all_stats['status']
      end

      status
    end

    params do
      requires :id, type: Integer, desc: 'Fragment ID'
    end

    post 'new_url' do
      fragment = Fragment.find(params[:id])
      fragment.url
    end
  end
end

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
      requires :id, type: String, desc: 'Fragment ID'
    end

    post 'fragments/resources/id' do
      fragment = Fragment.find(params[:id])
      url = fragment.url
      url = URI.parse(url)
      respond = CGI.parse(url.query)
      video_id = respond['v'].first

      video_from_cloud = Cloudinary::Api.resources_by_ids(video_id, :resource_type => :video)
      video_from_cloud
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
      requires :user_id, type: String, desc: 'User ID'
    end

    post 'fragments/global/status' do
      user_id = params[:user_id]
      fragment = Fragment.where(user_id: user_id).last
      fragment.status
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

      Fragment.create({user_id: user_id,
                       video_id: params[:video_id],
                       url: params[:url],
                       start: params[:start],
                       end: params[:end],
                       title: params[:title],
                       description: params[:description],
                       status: params[:status]})
    end

    # params do
    #   optional :name, type: String, desc: 'name'
    #   optional :cloud_url, type: String, desc: 'cloud_url'
    # end
    #
    # post 'fragments/:id' do
    #   begin
    #     fragment = Fragment.find(params[:id])
    #     fragment.name = params[:name]
    #     fragment.cloud_url = params[:cloud_url]
    #     if fragment.save
    #       {
    #           status: :success
    #       }
    #       else
    #       error!({status: :error, message: fragment.errors.full_messages.first}) if fragment.errors.any?
    #     end
    #
    #   rescue ActiveRecord::RecordNotFound
    #     error!({status: :error, message: :not_found}, 404)
    #   end
    # end

    params do
      requires :id, type: Integer, desc: 'id'
    end

    delete 'fragments/delete/:id' do
      # begin
        fragment = Fragment.find(params[:id])
        fragment
      #   {
      #       status: :success
      #   } if fragment.delete
      # rescue ActiveRecord::RecordNotFound
      #   error!({status: :error, message: :not_found}, 404)
      # end
    end

    params do
      requires :user_id, type: Integer, desc: 'user_id'
    end

    delete 'fragments/delete_all' do
      #Fragment.where(user_id: params[:user_id]).delete
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
      job_id = CloudinaryWorker.perform_async(fragment.id)
    end

    params do
      requires :cloud_uri, type: String, desc: 'URL'
      optional :title, type: String, desc: 'title'
      optional :description, type: String, desc: 'description'
    end

    post 'fragments/uploaded_on_youtube' do
      cloud_uri = params[:cloud_uri]
      title = params[:title]
      description = params[:description]
      job_id = UploaderWorker.perform_async(title,description,cloud_uri)
    end

    params do
      requires :user_id, type: String, desc: 'User ID'
    end

    post 'fragments/uploaded_video_on_youtube' do
      user_id = params[:user_id]
      user = User.find(user_id)
      token = user.token
      fragment = Fragment.where(user_id: user_id).last

      title = fragment.title
      description = fragment.description
      cloud_url = fragment.cloud_url

      url = URI.parse(cloud_url)
      respond = CGI.parse(url.path).first
      url = respond.first
      url = url[20..url.size]
      cloud_url = url

      start = fragment.start
      i_end = fragment.end

      job_id = UploaderWorker.perform_async(token,title,description,cloud_url,start,i_end)
    end

    # post 'status_job' do
    #   user_id = 28
    #
    #   fragment = Fragment.where(user_id: user_id).last
    #   job_id = fragment.status
    #   all_stats = Sidekiq::Status::get_all job_id
    #
    #   if job_id == 'downloaded' || 'upload_on_cloud'
    #     status = 'complete'
    #   else
    #     status = all_stats['status']
    #   end
    #
    #   status
    #
    # end

    params do
      requires :id, type: String, desc: 'id'

    end

    post 'status_job/id' do

      all_stats = Sidekiq::Status::get_all params[:id]
      status = all_stats['status']
      status

      #worker = all_stats["worker"]
      #args = all_stats["args"]
      #update_time = all_stats["update_time"]
      #jid = all_stats["jid"]
    end

    # params do
    #   requires :id, type: String, desc: 'channel ID'
    # end

    post 'channel' do

      user = User.find(28)
      user_id = user.id
      token = user.token
      name = user.email
      # owner = Yt::ContentOwner.new owner_name: name, refresh_token: token
      account = Yt::Account.new refresh_token: token
      channel = Yt::Channel.new id: 'UCFRA75dCkcCD9X-QevTu4Qw', auth: account
      channel.title

    end
  end
end

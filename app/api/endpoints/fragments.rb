module Endpoints
  class Fragments < Grape::API
    get 'fragments', jbuilder: 'fragments' do
      @fragments = Fragment.all
    end

    get 'fragments/:id' do
        @fragments = Fragment.find(params[:id])
    end

    get 'fragments/resources' do
      user_id = 28
      fragment = Fragment.where(user_id: user_id).last
      url = fragment.url
      url = URI.parse(url)
      respond = CGI.parse(url.query)
      video_id = respond['v'].first

      @video_from_cloud = Cloudinary::Api.resources_by_ids(video_id, :resource_type => :video)
      # cloud = video_from_cloud
      # fragment.cloud_url = cloud['resources'].last['url']
      # fragmen.save
    end

    post 'fragments/status' do
      user_id = 28
      fragment = Fragment.where(user_id: user_id).last
      fragment.status

    end

    params do
      requires :url, type: String, desc: 'URL'
      requires :start, type: Integer, desc: 'Start'
      requires :end, type: Integer, desc: 'End'
      requires :title, type: String, desc: 'Title'
      optional :description, type: String, desc: 'Description'
      optional :video_id, type: String, desc: 'Video ID'
      optional :status, type: String, desc: 'status'
    end

    post 'fragments' do
      user_id = User.last.id

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
      begin
        fragment = Fragment.find(params[:id])
        {
            status: :success
        } if fragment.delete
      rescue ActiveRecord::RecordNotFound
        error!({status: :error, message: :not_found}, 404)
      end
    end

    # params do
    #   requires :user_id, type: Integer, desc: 'user_id'
    # end
    #
    # delete 'fragments/delete_all' do
    #   fragment = Fragment.where(user_id: params[:user_id]).delete
    # end

    params do
      requires :user_id, type: String, desc: 'user_id'
    end

    post 'fragments/uploaded_on_cloudinary' do
      fragment = Fragment.where(user_id: params[:user_id]).last
      # url = fragment.url
      # url = URI.parse(url)
      # respond = CGI.parse(url.query)
      # video_id = respond['v'].first
      # video = Cloudinary::Api.resource(video_id, :resource_type => :video)
      job_id = CloudinaryWorker.perform_async(fragment.id)
      # stats = Sidekiq::Status::get_all job_id
      # stats['status']
      #worker = all_stats["worker"]
      #args = all_stats["args"]
      #update_time = all_stats["update_time"]
      #jid = all_stats["jid"]
    end

    params do
      requires :cloud_uri, type: String, desc: 'URL'
      optional :title, type: String, desc: 'title'
      optional :description, type: String, desc: 'description'
    end

    post 'fragments/uploaded_on_youtube' do
      #fragment = Fragment.find(params[:id])
      cloud_uri = params[:cloud_uri]
      title = params[:title]
      description = params[:description]
      job_id = UploaderWorker.perform_async(title,description,cloud_uri)
    end

    post 'status_job' do
      user_id = 28

      fragment = Fragment.where(user_id: user_id).last
      job_id = fragment.status
      allStats = Sidekiq::Status::get_all job_id
      status = allStats['status']

      #worker = all_stats["worker"]
      #args = all_stats["args"]
      #update_time = all_stats["update_time"]
      #jid = all_stats["jid"]
    end

    params do
      requires :id, type: String, desc: 'id'

    end

    post 'status_job/id' do

      allStats = Sidekiq::Status::get_all params[:id]
      status = allStats['status']

      #worker = all_stats["worker"]
      #args = all_stats["args"]
      #update_time = all_stats["update_time"]
      #jid = all_stats["jid"]
    end
  end
end

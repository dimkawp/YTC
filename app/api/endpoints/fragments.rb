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


    params do
      requires :url, type: String, desc: 'URL'
      optional :start, type: Integer, desc: 'start'
      optional :end, type: Integer, desc: 'end'
    end

    post 'fragments/embed_url' do
      @start = params[:start]
      @end = params[:end]
      url = URI.parse(params[:url])
      respond = CGI.parse(url.query)
      video_id = respond['v'].first
      embed = "https://www.youtube.com/embed/#{video_id}?start=#{@start}&end=#{@end}&autoplay=1"
    end

    params do
      requires :url, type: String, desc: 'URL'
      requires :start, type: Integer, desc: 'Start'
      requires :end, type: Integer, desc: 'End'
      requires :title, type: String, desc: 'Title'
    end

    post 'fragments' do
      user_id = User.last.id

      Fragment.create({user_id: user_id,
                       url: params[:url],
                       start: params[:start],
                       end: params[:end],
                       status: 'new'})
    end

    params do
      optional :name, type: String, desc: 'name'
      optional :cloud_url, type: String, desc: 'cloud_url'
    end

    post 'fragments/:id' do
      begin
        fragment = Fragment.find(params[:id])
        fragment.name = params[:name]
        fragment.cloud_url = params[:cloud_url]
        if fragment.save
          {
              status: :success
          }
          else
          error!({status: :error, message: fragment.errors.full_messages.first}) if fragment.errors.any?
        end


      rescue ActiveRecord::RecordNotFound
        error!({status: :error, message: :not_found}, 404)
      end
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

    # params do
    #   requires :user_id, type: Integer, desc: 'user_id'
    # end
    #
    # delete 'fragments/delete_all' do
    #   fragment = Fragment.where(user_id: params[:user_id]).delete
    # end

    params do
      requires :user_id, type: Integer, desc: 'user_id'
    end

    post 'fragments/download' do
      fragment = Fragment.where(user_id: params[:user_id]).last
      job_id = DownloadWorker.perform_async(fragment.id)
    end

    params do
      requires :url, type: String, desc: 'url'
    end

    post 'fragments/download/url' do
      url = params[:url]
      url = URI.parse(url)
      respond = CGI.parse(url.query)
      video_id = respond['v'].first

      job_id = DownloadWorker.perform_async(video_id)
    end
    #
    params do
      requires :start, type: Integer, desc: 'start'
      requires :end, type: Integer, desc: 'end'
      requires :url, type: String, desc: 'url'
    end

    post 'fragments/video/info' do

      url = params[:url]
      url = URI.parse(url)
      respond = CGI.parse(url.query)
      video_id = respond['v'].first

      embed = "https://www.youtube.com/embed/#{video_id}?start=#{params[:start]}&end=#{params[:end]}&autoplay=1"

      @video = Yt::Video.new id: video_id
       [embed: embed,
        id: @video.id,
        title: @video.title,
        description: @video.description,
        published_at: @video.published_at,
        thumbnail_url: @video.thumbnail_url,
        channel_id: @video.channel_id,
        channel_title: @video.channel_title,
        category_id: @video.category_id,
        category_title: @video.category_title,
        length: @video.length].first
    end

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
      stats = Sidekiq::Status::get_all job_id
      stats['status']
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

    params do
      requires :job_id, type: String, desc: 'job_id'
    end

    post 'status_job' do
      Sidekiq::Status::get_all params[:job_id]
      #worker = all_stats["worker"]
      #args = all_stats["args"]
      #update_time = all_stats["update_time"]
      #jid = all_stats["jid"]
    end
  end
end

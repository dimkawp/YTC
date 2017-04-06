module Endpoints
  class Fragments < Grape::API

    get 'fragments', jbuilder: 'fragments' do
      @fragments = Fragment.all
    end

    get 'fragments/:id' do
        @fragments = Fragment.find(params[:id])
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
      params = CGI.parse(url.query)
      video_id = params['v'].first

      "https://www.youtube.com/embed/#{video_id}?start=#{@start}&end=#{@end}&autoplay=1"
    end

    params do
      requires :url, type: String, desc: 'URL'
      requires :user_id, type: Integer, desc: 'user_id'
      optional :start, type: Integer, desc: 'start'
      optional :end, type: Integer, desc: 'end'
    end

    post 'fragments/create' do
      begin
        fragment = Fragment.create({
                                  url: params[:url],
                                  user_id: '28',
                                  start: params[:start],
                                  end: params[:end],
                                  status: 'new'
                                  })
        if fragment.save
          {
              status: :success
          }
        else
          error!(
              {
              status: :error, message: fragment.errors.full_messages.first
              }) if fragment.errors.any?
        end
      rescue ActiveRecord::RecordNotFound
        error!({status: :error, message: :not_found}, 404)
      end

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

    post 'download/:id' do
      fragment = Fragment.find(params[:id])
      job_id = DownloadWorker.perform_async(fragment.id)
    end

    post 'fragments/info/:id' do
      fragment = Fragment.find(params[:id])
      @url = fragment.url
      @video = Yt::Video.new id: @url[32..@url.size]
       [id: @video.id,
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

    post 'cloudinary/:id' do
      fragment = Fragment.find(params[:id])
      job_id = CloudinaryWorker.perform_async(fragment.id)
    end

  end
end

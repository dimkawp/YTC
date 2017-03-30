class FragmentController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:download, :cloudinary]

  def index
    @fragments = Fragment.all

    respond_to do |format|
      format.html
      format.json { render :json => @fragments }
    end
  end

  def show
    @fragment = Fragment.find(params[:id])
  end

  def url_id(url)
    uri = URI.parse(url)
    params = CGI.parse(uri.query)
    url = params['v']
  end

  def create
    #create new fragment url
    fragment = Fragment.new(fragment_params)
    fragment.user_id = session[:user_id]
    url = fragment.url
    url_id(url)
    session[:url_id] = url_id(fragment.url)
    if current_user.nil?
      flash[:success] = 'verify_authenticity'
      redirect_to root_url
    else
      fragment.name = current_user.first_name
    end

    if fragment.save
      #@link = Fragment.find(Fragment.last)
      #take fragment.id in worker download
      @job_id = DownloadWorker.perform_async(fragment.id)
      session[:job_id] = @job_id
      redirect_to root_url

      #if create , add url(this youtube url) in DL gem and download video
      # @fragment = Fragment.find(Fragment.last)
      # @url = @fragment.url
      # @url_name = @fragment.name
      #
      #  YoutubeDL.download @url, output: "video/#{@url_name}.mp4"
      #   #if download is ok, upload video file on cloudinary
      #   @response = Cloudinary::Uploader.upload("video/#{@url_name}.mp4", :resource_type => :video)
      #
      #   if @response.nil?
      #     File.delete("video/#{@url_name}.mp4")
      #     @fragment = Fragment.find(Fragment.last)
      #     @fragment.destroy
      #
      #     flash[:success] = 'Uploader on cloudinary is failed.'
      #
      #     redirect_to root_url
      #   else
      #     #if all ok, name = cloudinary public_id video
      #     @fragment.name = @response['public_id']
      #     if @fragment.save
      #       File.delete("video/#{@url_name}.mp4")
      #
      #       respond_to do |format|
      #         format.html { render 'home/index', @response }
      #         format.json { render :json => @response }
      #       end
      #       #builder url and save
      #       @fragment.url = "http://res.cloudinary.com/comedy/video/upload#{@params}/v1488899230/#{@fragment.name}.mp4"
      #       @fragment.save
      #
      #       flash[:success] = 'Uploader is END.'
      #     end
      #   end
      # else
      #   flash[:success] = 'The download video from YouTube is failed.'
      #
      #   redirect_to root_url
      # end
    else
      if current_user.nil?
        flash[:success] = 'Empty value url. or you not auth.'
      end
    end
  end

  def status_job(job_id)
    Sidekiq::Status::get_all job_id

    # @queued = Sidekiq::Status::queued?      job_id
    # @working = Sidekiq::Status::working?     job_id
    # @complete = Sidekiq::Status::complete?    job_id
    # @failed = Sidekiq::Status::failed?      job_id
    # @interrupted = Sidekiq::Status::interrupted? job_id
    #
    # @get = Sidekiq::Status::get     job_id, :vino
    # @at = Sidekiq::Status::at      job_id
    # @total = Sidekiq::Status::total   job_id
    # @message = Sidekiq::Status::message job_id
    # @pct = Sidekiq::Status::pct_complete job_id

    # render json: ['job_id': job_id,
    #               'status': @complete,
    #               'queued': @queued,
    #               'working': @working,
    #               'complete': @comlete,
    #               'failed': @failed,
    #               'interrupted': @interrupted,
    #               'get': @get,
    #               'at': @at,
    #               'total': @total,
    #               'message': @message,
    #               'pct': @pct,
    #               'data': @data]

  end

  def check_status_job
    all_stats = status_job(session[:job_id])
    #update_time = all_stats["update_time"]
    #jid = all_stats["jid"]
    status = all_stats["status"]
    #worker = all_stats["worker"]
    #args = all_stats["args"]
    render json: status

  end

  def video_size
    url_id = session[:url_id]
    File.size("video/#{url_id}.mp4")
  end

  def video_info
      @url_id = session[:url_id]
    render json: [video_size]

      #account = Yt::Account.new refresh_token: current_user.token

      # @video = Yt::Video.new id: @url_id #auth: account
      # if check_status_job == 'complete'
      #   @size = File.size("video/#{@url_id}.mp4")
      # else
      #   render json: [@video.id,
      #                 @video.title,
      #                 @video.description,
      #                 @video.published_at,
      #                 @video.thumbnail_url,
      #                 @video.channel_id,
      #                 @video.channel_title,
      #                 @video.category_id,
      #                 @video.category_title,
      #                 @video.length
      #
      #   #@video.file_size
      #   ]
      #end
      #@size = File.size("video/#{@url_id}.mp4")

  end

  def download
    DownloadWorker.perform_async(session[:url_id])
    redirect_to root_url

  end

  def video_from_cloud
    video = Cloudinary::Api.resources_by_ids(session[:url_id], :resource_type => :video)
    video_json = video["resources"]
    public_id = video_json[0]["public_id"]
    render json: public_id
  end

  def cloudinary

      @job_id = CloudinaryWorker.perform_async(session[:url_id])
      session[:job_id] = @job_id

      redirect_to root_url

  end

  def destroy
    @fragment = Fragment.find(params[:id])
    @fragment.destroy
  end

  private

  def fragment_params
    params.require(:fragment).permit(:user_id, :name, :url)
  end
end

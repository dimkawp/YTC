class FragmentController < ApplicationController

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
    url = params['v'].first

  end

  def create

    #create new fragment url
    fragment = Fragment.new(fragment_params)
    fragment.user_id = session[:user_id]
    url = fragment.url
    session[:url_id] = url_id(url)
    if current_user.nil?
      flash[:success] = 'verify_authenticity'
      redirect_to root_url
    else
      fragment.name = current_user.first_name
    end

    if fragment.save
      #take fragment.id in worker download
      @job_id = DownloadWorker.perform_async(fragment.id)
      session[:job_id] = @job_id
      redirect_to root_url
    else
      if current_user.nil?
        flash[:success] = 'Empty value url. or you not auth.'
      end
    end

  end

  def status_job(job_id)

    Sidekiq::Status::get_all job_id

  end

  def check_status_job

    all_stats = status_job(session[:job_id])
    status = all_stats["status"]
    #worker = all_stats["worker"]
    #args = all_stats["args"]
    #update_time = all_stats["update_time"]
    #jid = all_stats["jid"]
    render json: status

  end

  def video_size

    url_id = session[:url_id]
    File.size("tmp/video/#{url_id}.mp4")

  end

  def video_info

    url_id = session[:url_id].first
    @video = Yt::Video.new id: url_id
     render json: [@video.id,
                   @video.title,
                   @video.description,
                   @video.published_at,
                   @video.thumbnail_url,
                   @video.channel_id,
                   @video.channel_title,
                   @video.category_id,
                   @video.category_title,
                   @video.length
    ]

  end

  def video_from_cloud

    video = Cloudinary::Api.resources_by_ids(session[:url_id], :resource_type => :video)

  end

  def cloud_public_id

      render json: video_from_cloud

  end

  def cloudinary

      job_id = CloudinaryWorker.perform_async(session[:url_id])
      flash[:success] = 'Video upload on c;oudinary'
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

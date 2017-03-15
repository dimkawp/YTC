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
    #@fragment = Fragment.where(user_id: session[:user_id])

  end

  def create
    #create new fragment url
    @fragment = Fragment.new(fragment_params)
    @fragment.user_id = session[:user_id]
    if current_user.nil?
      flash[:success] = "Need authefication"
      redirect_to root_url
    else
      #initializers fragment with params
      @fragment.name = current_user.first_name
      session[:start] = params['offset']['start']
      session[:end] = params['offset']['end']
      #create params
      @params = "/eo_#{session[:end]},so_#{session[:start]}"
    end

    if @fragment.save
      #if create , add url(this youtube url) in DL gem and download video
      @fragment = Fragment.find(Fragment.last)
      @url = @fragment.url
      @url_name = @fragment.name

      if YoutubeDL.download @url, output: "video/#{@url_name}.mp4"
        #if download is ok, upload video file on cloudinary
        @response = Cloudinary::Uploader.upload("video/#{@url_name}.mp4", :resource_type => :video)

        if @response.nil?
          File.delete("video/#{@url_name}.mp4")
          @fragment = Fragment.find(Fragment.last)
          @fragment.destroy
          flash[:success] = "Uploader on cloudinary is failed."
          redirect_to root_url
        else
          #if all ok, name = cloudinary public_id video
          @fragment.name = @response['public_id']
          if @fragment.save
            File.delete("video/#{@url_name}.mp4")

            respond_to do |format|
              format.html { render 'home/index', @response }
              format.json { render :json => @response }
            end
            #builder url and save
            @fragment.url = "http://res.cloudinary.com/comedy/video/upload#{@params}/v1488899230/#{@fragment.name}.mp4"
            @fragment.save
            flash[:success] = "Uploader is END."
          end
        end

      else
        flash[:success] = "The download video from YouTube is failed."
        redirect_to root_url
      end

    else
      if current_user.nil?
        flash[:success] = "Empty value url. or you not auth."
      else

      end

    end
  end

  def video_info
      @id_url = params['fragment']['url']
      @video = Yt::Video.new id: @id_url[32..@id_url.size]
      #render json: @id_url[32..@id_url.size]
      render json: [@video.id,
                    @video.title,
                    @video.description,
                    @video.published_at,
                    @video.thumbnail_url,
                    @video.channel_id,
                    @video.channel_title,
                    @video.category_id,
                    @video.category_title]
    end
  def download

  end

  def cloudinary

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

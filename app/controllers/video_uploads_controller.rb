class VideoUploadsController < ApplicationController
  def index

  end

  def new
    @video_uploads = VideoUploader.new
    @all_fragments_user = Fragment.find(params[:id])
  end

  def create
    @all_fragments_user = Fragment.find(params[:id])

    @video_uploads = VideoUploader.new(title: params[:video_uploads][:title],
                                       description: params[:video_uploads][:description],
                                       file: @all_fragments_user.cloud_url)
    #render json: @video_uploads

    if @video_uploads.save
      uploaded_video = @video_uploads.upload!(current_user)

      if uploaded_video.failed?
        flash[:success] = 'There was an error uploading your video'
      else
        flash[:success] = 'Your video has been uploaded!'
      end
      redirect_to root_url
    else
      render :new
    end
  end

  def destroy
    @fragment = Fragment.find(params[:id])
    @fragment.destroy
  end
end

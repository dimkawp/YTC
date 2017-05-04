class HomeController < ApplicationController
  def index

  end

  def test
    # job_id = YoutubeDownloaderWorker.perform_async(555)

    # if Sidekiq::Status::failed? 'd221edd867aa3be918d7c688'
    #   render json: 'test'
    # end

    status = Sidekiq::Status::status('d221edd867aa3be918d7c688')

    if status.to_s == 'failed'
      # || status === 'interrupted'
      exit
    end

    # render json: status

    # file = "tmp/video/zS1ZAGIYIVc.mp4"
    #
    # @video = YoutubeDL.download "https://www.youtube.com/watch?v=zS1ZAGIYIVc", output: file, 'max-filesize': '40m'
    #
    # render json: @video.information[:formats]
  end
end

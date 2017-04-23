module FragmentHelper
  def get_video_id(url)
    url = URI.parse(url)
    params = CGI.parse(url.query)
    params['v'].first
  end

  def get_embed_url(data)
    # @start = params[:start]
    # @end = params[:end]
    # url = URI.parse(params[:url])
    # respond = CGI.parse(url.query)
    # video_id = respond['v'].first
    "https://www.youtube.com/embed/#{data.video_id}?start=#{data.start}&end=#{data.end}&autoplay=1"
  end
end

module Endpoints
  class Fragments < Grape::API
    get 'fragments', jbuilder: 'fragments' do
      @fragments = Fragment.all
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

  end
end

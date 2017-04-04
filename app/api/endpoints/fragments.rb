module Endpoints
  class Fragments < Grape::API
    get 'fragments', jbuilder: 'fragments' do
      @fragments = Fragment.all
    end

    params do
      requires :url, type: String, desc: 'URL'
    end

    post 'fragments/embed_url' do
      url = URI.parse(params[:url])
      params = CGI.parse(url.query)
      video_id = params['v'].first

      "https://www.youtube.com/embed/#{video_id}"
    end
  end
end

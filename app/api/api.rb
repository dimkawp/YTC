require 'grape-swagger'

module Api
  class API < Grape::API
    format :json
    formatter :json, Grape::Formatter::Jbuilder

    helpers do
      #take id from url
      def get_v(url)
        components = URI.parse(url)

        params = CGI.parse(components.query)
        params['v'].first
      end
      #check role admin token
      def check_admin(token)
        user = User.where(access_token: token)
        if user.first.role == 'admin'
          true
        else
          false
        end
      end
    end

    mount Endpoints::Admin
    mount Endpoints::Videos
    mount Endpoints::Users
    mount Endpoints::Fragments

    add_swagger_documentation hide_documentation_path: true,
                              api_version: 'v1',
                              format: :json
  end
end

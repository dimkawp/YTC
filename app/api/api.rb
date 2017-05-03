require 'grape-swagger'

module Api
  class API < Grape::API
    format :json
    formatter :json, Grape::Formatter::Jbuilder

    mount Endpoints::Videos
    mount Endpoints::Users
    mount Endpoints::Fragments

    add_swagger_documentation hide_documentation_path: true,
                              api_version: 'v1',
                              format: :json
  end
end

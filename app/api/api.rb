class Api < Grape::API
  version 'v1', using: :path

  mount Users::All
  mount Fragments::All
  add_swagger_documentation
end

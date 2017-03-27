class API < Grape::API
  prefix 'api'
  version 'v1', using: :path
  mount Users::All
  mount Fragments::All
end
class API < Grape::API
  version 'v1', using: :path

  mount Users::All
  mount Fragments::All
end

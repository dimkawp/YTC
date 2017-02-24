require 'faker'

user_ids = User.pluck(:id)

1.times do
  user_id = user_ids.sample
  name    = Faker::Lorem.sentence
  url     = Faker::Placeholdit.image

  Fragment.create(user_id: user_id, name: name, url: url)
end

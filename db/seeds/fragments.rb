require 'faker'

user_ids = User.pluck(:id)

15.times do
  users_id     = user_ids.sample
  name        = Faker::Name.name
  url         = Faker::Twitter.user

  Fragment.create(users_id: users_id, name: name, url: url)
end
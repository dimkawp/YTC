require 'faker'

3.times do
  email      = Faker::Internet.email
  first_name = Faker::Name.first_name
  last_name  = Faker::Name.last_name

  User.create(email: email, first_name: first_name, last_name: last_name)
end
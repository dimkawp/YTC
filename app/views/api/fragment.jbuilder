json.id @fragment.id
json.user do
  json.name @fragment.user.name
  json.email @fragment.user.email
end
json.url @fragment.url
json.title @fragment.title
json.start @fragment.start
json.end @fragment.end
json.description @fragment.description
json.status @fragment.status

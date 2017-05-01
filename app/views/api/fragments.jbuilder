json @fragments do |fragment|
  json.id fragment.id
  json.user do
    json.name fragment.user.name
    json.email fragment.user.email
  end
  json.video_id fragment.video_id
  json.title fragment.title
  json.description fragment.description
  json.url fragment.url
  json.cloud_url fragment.cloud_url
  json.start fragment.start
  json.end fragment.end
  json.status fragment.status
end

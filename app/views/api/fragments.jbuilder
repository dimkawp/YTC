json.array! @fragments do |fragment|
  json.id fragment.id
  json.video do
    json.v fragment.video.v
  end
  json.url fragment.url
  json.title fragment.title
  json.start_from fragment.start_from
  json.end_from fragment.end_from
  json.description fragment.description
  json.status fragment.status
end

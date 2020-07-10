json.array! @friends do |friend|
  json.id            friend.id
  json.name          friend.name
  json.description   friend.description
  json.avatar        friend.avatar_url
end
json.array! @users do |user|
  json.id            user.id
  json.name          user.name
  json.description   user.description
  json.avatar        user.avatar_url
end
json.array! @users_applying_for_friends_to_me do |user|
  json.id            user.id
  json.name          user.name
  json.description   user.description
  json.avatar        user.avatar_url
end
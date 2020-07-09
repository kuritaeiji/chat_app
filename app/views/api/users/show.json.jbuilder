json.user do
  json.id            @user.id
  json.name          @user.name
  json.description   @user.description
  json.identifier_id @user.identifier_id
  json.avatar        @user.encoded_avatar
end
json.user do
  json.name          @user.name
  json.description   @user.description
  json.identifier_id @user.identifier_id
  # json.avatar
end
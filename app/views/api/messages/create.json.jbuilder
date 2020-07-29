json.set! :message do
  json.content @message.content
  json.avatar  @message.avatar_url
end

json.set! :user do
  json.id            @message.user.id
  json.name          @message.user.name
  json.description   @message.user.description
  json.identifier_id @message.user.identifier_id
  json.avatar        @message.user.avatar_url
end
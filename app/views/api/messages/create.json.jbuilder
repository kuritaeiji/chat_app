json.set! :message do
  json.id          @message.id
  json.content     @message.content
  json.avatar      @message.avatar_url
  json.created_at  @message.created_at_to_string
end

json.set! :user do
  json.id            @message.user.id
  json.name          @message.user.name
  json.description   @message.user.description
  json.identifier_id @message.user.identifier_id
  json.avatar        @message.user.avatar_url
end
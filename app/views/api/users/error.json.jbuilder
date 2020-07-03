json.set! :error_messages do
  json.array! @user.errors.full_messages do |message|
    json.message message
  end
end
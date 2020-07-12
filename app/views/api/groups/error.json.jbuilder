json.set! :error_messages do
  json.array! @group.errors.full_messages do |message|
    json.message   message
  end
end
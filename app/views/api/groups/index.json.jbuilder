json.array! @groups do |group|
  json.id                    group.id
  json.name                  group.name
  json.avatar                group.avatar_url
  json.unread_messages_count_by_group group.unread_messages_count_by_group
end
json.array! @groups do |group|
  json.id       group.id
  json.name     group.name
  json.avatar   group.avatar_url
end
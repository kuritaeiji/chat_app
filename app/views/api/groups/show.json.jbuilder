json.group do |group|
  group.id       @group.id
  group.name     @group.name
  group.avatar   @group.avatar_url
  group.user_ids @group.return_user_ids
end
User.create!(
  name: 'example',
  email: 'example@example.com',
  description: 'example',
  password: 'example',
  password_confirmation: 'example',
  identifier_id: 'example',
  activated: true,
  activated_at: Time.zone.now
)

20.times do |n|
  User.create!(
    name: "#{n}example",
    email: "#{n}example@example.com",
    description: "#{n}example",
    password: "#{n}example",
    password_confirmation: "#{n}example",
    identifier_id: "#{n}example",
    activated: true,
    activated_at: Time.zone.now
  )
end

user = User.first
users = User.all.order(created_at: :desc).take(10)
approved_users = users[0..4]
not_approved_users = users[5..9]

approved_users.each do |u|
  user.apply_for_friend_to(u)
  u.approve_friend_from(user)
end

not_approved_users.each do |u|
  u.apply_for_friend_to(user)
end

5.times do |n|
  user_ids = [user.id.to_s, (n + 2).to_s]
  Group.create!(
    name: "#{n}example_group",
    user_ids: user_ids
  )
end

groups = Group.all.take(5)
groups.each do |group|
  group.users.each do |user|
    100.times do
      user.messages.create(content: 'example', group_id: group.id)
    end
  end
end

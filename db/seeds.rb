# User.create!(
#   name: 'example',
#   email: 'example@example.com',
#   description: 'example',
#   password: 'example',
#   password_confirmation: 'example',
#   identifier_id: 'example',
#   activated: true,
#   activated_at: Time.zone.now
# )

20.times do |n|
  User.create!(
    name: "#{n}example",
    email: "#{n}example@example.com",
    description: "#{n}example",
    password: "#{n}example",
    password_confirmation: "#{n}example",
    identifier_id: SecureRandom.hex(8),
    activated: true,
    activated_at: Time.zone.now
  )
end


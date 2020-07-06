FactoryBot.define do
  factory :user do
    sequence(:name)         { |n| "#{n}example" }
    sequence(:email)        { |n| "#{n}example@example.co.jp" }
    password                { 'password' }
    password_confirmation   { 'password' }
    identifier_id           { 'example' }
    activated               { true }
    activated_at            { Time.zone.now }
    activation_digest       { nil }
  end
end
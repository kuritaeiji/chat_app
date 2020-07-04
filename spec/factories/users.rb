FactoryBot.define do
  factory :user do
    sequence(:name)         { |n| "#{n}example" }
    sequence(:email)        { |n| "#{n}example@example.co.jp" }
    password                { 'password' }
    password_confirmation   { 'password' }
    identifier_id           { 'example' }
  end
end
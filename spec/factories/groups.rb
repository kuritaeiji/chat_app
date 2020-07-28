FactoryBot.define do
  factory :group do
    sequence(:name) { |n| "#{n}example" }
  end
end

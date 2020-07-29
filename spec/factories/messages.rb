FactoryBot.define do
  factory :message do
    user
    group
    content { 'example' }
  end
end

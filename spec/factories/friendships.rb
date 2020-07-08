FactoryBot.define do
  factory :friendship do
    association :requesting_user, factory: :user
    association :requested_user, factory: :user
    approved { true }
  end
end

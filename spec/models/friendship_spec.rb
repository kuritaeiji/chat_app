require 'rails_helper'

RSpec.describe Friendship, type: :model do
  it 'belongs_to :requesting_user' do
    user = create(:user)
    friendship = create(:friendship, requesting_user: user)
    expect(friendship.requesting_user).to eq(user)
  end

  it 'belongs_to :requested_user' do
    user = create(:user)
    friendship = create(:friendship, requested_user: user)
    expect(friendship.requested_user).to eq(user)
  end

  it 'requesting_user_idとrequested_user_idは一意' do
    user_a = create(:user)
    user_b = create(:user)
    friendship_a = create(:friendship, requesting_user: user_a, requested_user: user_b)

    friendship_b = build(:friendship, requesting_user: user_a, requested_user: user_b)
    friendship_b.valid?
    expect(friendship_b).not_to be_valid
    expect(friendship_b.errors[:attribute][0]).to eq('既に友達申請もしくは登録しています。')

    friendship_c = build(:friendship, requesting_user: user_b, requested_user: user_a)
    friendship_c.valid?
    expect(friendship_c).not_to be_valid
    expect(friendship_c.errors[:attribute][0]).to eq('既に友達申請もしくは登録しています。')
  end
end

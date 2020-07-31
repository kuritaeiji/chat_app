require 'rails_helper'

RSpec.describe Group, type: :model do
  include Api::CookiesHelper
  let(:cookies) { ActionDispatch::Request.empty.cookie_jar }

  describe 'name validation' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(20) }
  end

  describe 'avatar validation' do
    it 'valid image' do
      group = create(:group)
      group.avatar.attach(io: File.open('/app/chat_app/spec/images/default.jpg'), filename: 'default.jpg')
      expect(group.avatar).to be_valid
    end

    it 'invalid image' do
      group = create(:group)
      group.avatar.attach(io: File.open('/app/chat_app/spec/models/friendship_spec.rb'), filename: 'friendship.rb')
      expect(group.errors[:avatar][0]).to eq('には画像しか使用できません。')
    end
  end

  it 'return_user_ids' do
    group = create(:group)
    user_a = create(:user)
    user_b = create(:user)
    member_a = create(:member, group: group, user: user_a)
    member_b = create(:member, group: group, user: user_b)
    
    expect(group.return_user_ids).to eq([user_a.id, user_b.id])
  end

  it 'set_unread_messages_count_by_group' do
    user_a = create(:user)
    login(user_a)
    group = create(:group)
    user_b = create(:user)
    member_a = create(:member, group: group, user: user_a)
    member_b = create(:member, group: group, user: user_b)
    create_list(:message, 5, group: group, user: user_a)
    create_list(:message, 10, group: group, user: user_b)

    group = Group.last
    group.set_unread_messages_count_by_group(current_user)
    expect(group.unread_messages_count_by_group).to eq(10)
  end
end

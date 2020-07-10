require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'name validation' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(20) }
  end

  describe 'email validation' do
    it { is_expected.to validate_presence_of(:email) }

    it '無効なメールアドレス' do
      user = build(:user, email: 'example.jp')
      expect(user).not_to be_valid
    end
  end

  describe 'email uniqueness validation' do # データベースのnot null制約に引っかかるため
    subject { create(:user) }
    it { is_expected.to validate_uniqueness_of(:identifier_id) }
  end

  describe 'password validation' do
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
  end

  describe 'identifier_id validation' do
    it { is_expected.to validate_presence_of(:identifier_id) }
    it { is_expected.to validate_length_of(:identifier_id).is_at_most(20) }

    it '無効なユーザーID' do
      user = build(:user, identifier_id: 'アイウエオ')
      expect(user).not_to be_valid
    end
  end

  describe 'identifier_id uniqueness validation' do
    subject { create(:user) }
    it { is_expected.to validate_uniqueness_of(:identifier_id) }
  end

  it 'imageableロール' do
    user = create(:user)
    expect(user).to respond_to(:attach_image)
  end

  it 'create_activation_token_and_digest' do
    user = create(:user)
    user.create_activation_token_and_digest

    expect(BCrypt::Password.new(user.activation_digest) == user.activation_token).to eq(true)
  end

  describe 'Friendshipモデルに関わるインターフェース' do
    before do
      @user_a = create(:user)
      @user_b = create(:user)
      @user_c = create(:user)
    end

    it 'friends' do
      friendship_ab = create(:friendship, requesting_user: @user_a, requested_user: @user_b)
      friendship_ac = create(:friendship, requesting_user: @user_a, requested_user: @user_c)

      expect(@user_a.friends).to eq([@user_b, @user_c])
    end

    it 'users_applying_for_friends_to_me' do
      friendship_ba = create(:friendship, requesting_user: @user_b, requested_user: @user_a, approved: false)
      friendship_ca = create(:friendship, requesting_user: @user_c, requested_user: @user_a, approved: false)

      expect(@user_a.users_applying_for_friends_to_me).to eq([@user_b, @user_c])
    end

    it 'users_count_applying_for_friends_to_me' do
      friendship_ba = create(:friendship, requesting_user: @user_b, requested_user: @user_a, approved: false)
      friendship_ca = create(:friendship, requesting_user: @user_c, requested_user: @user_a, approved: false)

      expect(@user_a.users_count_applying_for_friends_to_me).to eq(2)
    end

    it 'apply_for_friend_to(other_user)' do
      @user_b.apply_for_friend_to(@user_a)
      expect(@user_a.users_applying_for_friends_to_me).to include(@user_b)
    end

    it 'approve_friend_from(other_user)' do
      friendship_ab = create(:friendship, requesting_user: @user_a, requested_user: @user_b, approved: false)
      @user_b.approve_friend_from(@user_a)
      expect(Friendship.first.approved).to eq(true)
    end

    it 'delete_friend(other_user)' do
      friendship_ab = create(:friendship, requesting_user: @user_a, requested_user: @user_b)
      @user_a.delete_friend(@user_b)
      expect(Friendship.count).to eq(0)
    end
  end
end

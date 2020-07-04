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
end

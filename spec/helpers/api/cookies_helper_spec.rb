require 'rails_helper'

RSpec.describe Api::CookiesHelper, type: :helper do
  include Api::CookiesHelper
  describe 'login(user)' do
    it 'cookieを作成する' do
      user = create(:user)
      login(user)
      expect(cookies[:user_id]).to eq(user.id)
    end
  end

  describe 'current_user' do
    it 'ログインしている時current_userを返す' do
      user = create(:user)
      login(user)

      expect(current_user).to eq(user)
    end

    it 'ログインしていない時nilを返す' do
      expect(current_user).to be(nil)
    end
  end

  describe 'logged_in?(user)' do
    it 'ログインしている時trueを返す' do
      user = create(:user)
      login(user)

      expect(logged_in?(user)).to eq(true)
    end

    it 'ログインしていない時falseを返す' do
      user = create(:user)

      expect(logged_in?(user)).to eq(false)
    end
  end
end

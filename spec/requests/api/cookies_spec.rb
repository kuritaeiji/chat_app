require 'rails_helper'

RSpec.describe "Api::Cookies", type: :request do
  describe 'destroy' do
    it 'cookieを削除する' do
      user = create(:user)
      cookies.signed[:user_id] = { value: user.id, expired: 1.year.from_now }
      delete "/api/cookies/#{user.id}"
      json = JSON.parse(response.body)

      expect(cookies[:user_id]).to eq('')
      expect(json['message']).to eq('success')
      expect(response.status).to eq(200)
    end
  end

  describe 'create' do
    it '正しいパスワードとメールアドレスが入力された時cookieを作成する' do
      user = create(:user)
      post '/api/cookies', params: { cookie: { email: user.email, password: user.password } }
      json = JSON.parse(response.body)

      expect(cookies.signed[:user_id].present?).to be_truthy
      expect(json['user']['id']).to eq(user.id)
      expect(response.status).to eq(200)
    end

    it '正しくないパスワードとメールアドレスが入力された時エラーメッセージを返す' do
      user = create(:user)
      post '/api/cookies', params: { cookie: { email: 'fffff@fff.com', password: 'fff' } }
      json = JSON.parse(response.body)

      expect(cookies[:user_id]).to eq(nil)
      expect(json['error_message']).to eq('メールアドレスもしくはパスワードが間違っています。')
      expect(response.status).to eq(200)
    end
  end
end

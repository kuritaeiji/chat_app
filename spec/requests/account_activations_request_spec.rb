require 'rails_helper'

RSpec.describe "AccountActivations", type: :request do
  describe 'new' do
    it 'ユーザーが有効化されていない時有効化する' do
      activation_token = SecureRandom.base64
      activation_digest = BCrypt::Password.create(activation_token)
      user = create(:user, activated: false, activated_at: nil, activation_digest: activation_digest)
      get '/account_activations/new', params: { email: user.email, activation_token: activation_token }

      expect(cookies[:user_id]).to eq(user.id.to_s)
      expect(response).to redirect_to('http://www.example.com/')
    end

    it 'ユーザーが有効化されている時ログイン画面へリダイレクト' do
      activation_token =  SecureRandom.base64
      user = create(:user)
      get '/account_activations/new', params: { email: user.email, activation_token: activation_token }

      expect(response).to redirect_to('http://www.example.com/login')
    end
  end
end

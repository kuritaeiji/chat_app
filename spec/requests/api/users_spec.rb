require 'rails_helper'

RSpec.describe "Api::Users", type: :request do
  describe 'create' do
    it '新しいユーザーを作成する' do
      valid_params = attributes_for(:user)
      expect { post '/api/users', params: { user: valid_params }}.to change(User, :count)
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json['message']).to eq('success')
    end

    it '不正な値の時エラーメッセージを返す' do
      invalid_params = attributes_for(:user, email: '')
      expect { post '/api/users', params: { user: invalid_params }}.not_to change(User, :count)

      json = JSON.parse(response.body)
      expect(json['error_messages'])
    end
  end

  describe 'show' do
    it 'ユーザー情報を返す' do
      user = create(:user)
      get "/api/users/#{user.id}"
      json = JSON.parse(response.body)

      expect(json['user']['name']).to eq(user.name)
    end
  end
end

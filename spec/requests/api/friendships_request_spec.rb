require 'rails_helper'

RSpec.describe "Api::Friendships", type: :request do
  include Api::CookiesHelper
  before do
    @user = create(:user)
    @user_b = create(:user)
    login(@user)
  end

  describe 'index' do
    it '友達が存在する時' do
      create_list(:friendship, 10, requesting_user: @user)
      get "/api/users/#{@user.id}/friendships"
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json.length).to eq(10)
    end

    it '友達が存在しない時' do
      get "/api/users/#{@user.id}/friendships"
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json['message']).to eq('友達がいません')
    end
  end

  describe 'users_applying_for_friends_to_me' do
    it 'フレンド申請してきているユーザーがいる時' do
      create_list(:friendship, 10, requested_user: @user, approved: false)
      get "/api/users/#{@user.id}/friendships/users_applying_for_friends_to_me"
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json.length).to eq(10)
    end
    
    it 'フレンド申請してきているユーザーがいない時' do
      get "/api/users/#{@user.id}/friendships/users_applying_for_friends_to_me"
      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json['message']).to eq('申請してきているユーザーはいません')
    end
  end

  describe 'create' do
    it 'フレンド申請ができる時' do
      expect { post "/api/users/#{@user.id}/friendships", params: { requested_user_id: @user_b.id } }.to change(Friendship, :count)
      expect(response.status).to eq(200)
    end

    it 'フレンド申請が失敗する時' do
      create(:friendship, requesting_user: @user, requested_user: @user_b)
      expect { post "/api/users/#{@user.id}/friendships", params: { requested_user_id: @user_b.id } }.not_to change(Friendship, :count)
      expect(response.status).to eq(200)
    end
  end

  describe 'approve' do
    it 'フレンド承認ができる' do
      friendship = create(:friendship, requesting_user: @user, requested_user: @user_b, approved: false)
      put "/api/users/#{@user_b.id}/friendships/approve", params: { requesting_user_id: @user.id }

      expect(@user_b.users_applying_for_friends_to_me).to eq([])
      expect(response.status).to eq(200)
    end
  end

  describe 'destroy_friend' do
    it 'フレンド解除ができる' do
      create(:friendship, requesting_user: @user, requested_user: @user_b)
      expect { delete "/api/users/#{@user.id}/friendships/destroy_friend", params: { detroying_user_id: @user_b.id } }.to change(Friendship, :count)
      expect(response.status).to eq(200)
    end
  end
end

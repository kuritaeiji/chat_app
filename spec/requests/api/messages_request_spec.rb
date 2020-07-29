require 'rails_helper'

RSpec.describe "Api::Messages", type: :request do
  include Api::CookiesHelper
  before do
    @current_user = create(:user)
    login(@current_user)

    @user_a = create(:user)
    @group = create(:group)
    @member_current = create(:member, user: @current_user, group: @group)
    @member_a = create(:member, user: @user_a, group: @group)
  end

  describe 'index' do
    it 'メッセージを返す' do
      create_list(:message, 5, group: @group, user: @user_a)
      create_list(:message, 5, group: @group, user: @current_user)

      get "/api/groups/#{@group.id}/messages", params: { last_read_id: '0' }
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json.length).to eq(10)
    end

    it 'メッセージがない時' do
      get "/api/groups/#{@group.id}/messages", params: { last_read_id: '0' }
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json['message']).to eq('新規メッセージはありません')
    end
  end

  describe 'create' do
    it 'メッセージを作成できる時' do
      valid_params = { content: 'example', avatar: nil }
      expect { post "/api/groups/#{@group.id}/messages", params: { message: valid_params } }.to change(Message, :count).by(+1)
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json['message']['content']).to eq(valid_params[:content])
      expect(json['user']['name']).to eq(@current_user.name)
    end

    it 'メッセージを作成できない時エラーを返す' do
      invalid_params = { content: 'a' * 201, avatar: nil }
      expect { post "/api/groups/#{@group.id}/messages", params: { message: invalid_params } }.not_to change(Message, :count)
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json['error_messages'][0]['message']).to eq('メッセージは200文字以内で入力してください')
    end
  end
end

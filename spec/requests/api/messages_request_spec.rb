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
      create_list(:message, 50, group: @group, user: @user_a)
      create_list(:message, 50, group: @group, user: @current_user)

      get "/api/groups/#{@group.id}/messages"
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json.length).to eq(50)
      expect(json[0]['older_messages_present']).to eq(true)
    end

    it '50以上のメッセージがない時older_messages_presentはfalse' do
      create_list(:message, 10, group: @group, user: @current_user)
      get "/api/groups/#{@group.id}/messages"
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json.length).to eq(10)
      expect(json[0]['older_messages_present']).to eq(false)
    end

    it 'メッセージがない時' do
      get "/api/groups/#{@group.id}/messages"
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json['message']).to eq('新規メッセージはありません')
    end
  end

  describe 'return_new_messages' do
    it 'メッセージが存在する時' do
      message = create(:message, group: @group, user: @user_a)
      create_list(:message, 10, group: @group, user: @user_a)
      get "/api/groups/#{@group.id}/messages/return_new_messages", params: { last_message_id: message.id.to_s }
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json.length).to eq(10)
    end

    it 'カレントユーザーのメッセージは返さない' do
      message = create(:message, group: @group, user: @user_a)
      create(:message, group: @group, user: @current_user)
      get "/api/groups/#{@group.id}/messages/return_new_messages", params: { last_message_id: message.id.to_s }
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json['message']).to eq('新規メッセージはありません')
    end

    it 'メッセージが存在しない時' do
      get "/api/groups/#{@group.id}/messages/return_new_messages", params: { last_message_id: '0' }
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json['message']).to eq('新規メッセージはありません')
    end
  end

  describe 'return_older_messages' do
    it 'メッセージが存在しさらに古いメッセージも存在する時' do
      create_list(:message, 60, group: @group, user: @user_a)
      message = create(:message, group: @group, user: @user_a)
      get "/api/groups/#{@group.id}/messages/return_older_messages", params: { first_message_id: message.id.to_s }
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json.length).to eq(50)
      expect(json[0]['older_messages_present']).to eq(true)
    end

    it 'メッセージは存在するがさらに古いメッセージは存在しない時older_messages_presentはfalse' do
      create_list(:message, 2, group: @group, user: @user_a)
      message = create(:message, group: @group, user: @user_a)
      get "/api/groups/#{@group.id}/messages/return_older_messages", params: { first_message_id: message.id.to_s }
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json.length).to eq(2)
      expect(json[0]['older_messages_present']).to eq(false)
    end

    it 'メッセージが存在しない時' do
      message = create(:message, group: @group, user: @user_a)
      get "/api/groups/#{@group.id}/messages/return_older_messages", params: { first_message_id: message.id.to_s }
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json['message']).to eq('メッセージはありません')
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

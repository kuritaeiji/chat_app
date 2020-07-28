require 'rails_helper'

RSpec.describe "Api::Groups", type: :request do
  include Api::CookiesHelper
  before do
    @current_user = create(:user)
    login(@current_user)
  end

  describe 'index' do
    it 'グループを返す' do
      groups = create_list(:group, 10)
      groups.each do |group|
        create(:member, user: @current_user, group: group)
      end

      get '/api/groups'
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json.length).to eq(10)
    end

    it 'グループのない時errorを返す' do
      get '/api/groups'
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json['message']).to eq('error')
    end
  end

  describe 'show' do
    it 'グループを返す' do
      group = create(:group)
      create(:member, user: @current_user, group: group)

      get "/api/groups/#{group.id}"
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json['group']['name']).to eq(group.name)
      expect(json['group']['avatar']).to eq(nil)
    end

    it 'グループのない時errorを返す' do
      get '/api/groups/1'
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json['message']).to eq('error')
    end
  end

  describe 'create' do
    it 'グループを作成する' do
      user = create(:user)
      file = File.read('spec/images/default.jpg')
      encoded_file = Base64.encode64(file)
      perfect_encoded_file = "data:image/jpeg;base64,#{encoded_file}"
      group = { name: 'example_group', avatar: perfect_encoded_file, user_ids: [@current_user.id, user.id] }

      expect { post '/api/groups', { params: { group: group } } }.to change(Group, :count)
      json = JSON.parse(response.body)
      expect(json['group_id']).to eq(Group.last.id)
      expect(Group.last.members.length).to eq(2)
      expect(Group.last.avatar.attached?).to eq(true)
    end

    it 'グループの作成に失敗する時エラーメッセージをかえす' do
      user = create(:user)
      group = { name: nil, avatar: nil, user_ids: [@current_user.id, user.id] }
      expect { post '/api/groups', { params: { group: group } } }.not_to change(Group, :count)
      json = JSON.parse(response.body)
      expect(json['error_messages'][0]['message']).to eq('グループ名を入力してください')
    end

    it 'グループのメンバーが二人で既に同じグループが存在している時グループを新規作成しない' do
      user = create(:user)
      group = create(:group)
      member = create(:member, user: user, group: group)
      member2 = create(:member, user: @current_user, group: group)
      group_params = { name: 'fffff', avatar: nil, user_ids: [@current_user.id, user.id]}

      expect { post '/api/groups', { params: { group: group_params } } }.not_to change(Group, :count)
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json['group_id']).to eq(group.id)
    end
  end

  describe 'update' do
    it 'グループをアップデートする' do
      group = create(:group)
      create(:member, user: @current_user, group: group)
      user = create(:user)
      group_params = { name: 'fffffff', avatar: nil, user_ids: [@current_user.id, user.id]}

      expect { put "/api/groups/#{group.id}", params: { group: group_params } }.to change(Member, :count)
      json = JSON.parse(response.body)
      expect(json['group_id']).to eq(group.id)
      expect(Group.last.name).to eq(group_params[:name])
    end

    it 'グループをアップデートできなかった時エラーメッセージを返す' do
      group = create(:group)
      create(:member, user: @current_user, group: group)
      group_params = { name: nil, avatar: nil, user_ids: [@current_user.id] }

      put "/api/groups/#{group.id}", params: { group: group_params }
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json['error_messages'][0]['message']).to eq('グループ名を入力してください')
    end
  end

  describe 'destroy' do
    it 'グループを削除する' do
      group = create(:group)
      create(:member, user: @current_user, group: group)

      expect { delete "/api/groups/#{group.id}" }.to change(Group, :count).by(-1)
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json['message']).to eq('success')
    end
  end

  describe 'leave_the_group' do
    it 'ユーザーがグループから抜ける' do
      group = create(:group)
      create(:member, user: @current_user, group: group)

      expect { delete "/api/groups/#{group.id}/leave_the_group" }.to change(Member, :count).by(-1)
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json['message']).to eq('success')
    end
  end

  describe 'friends_and_members' do
    it 'カレントユーザーのフレンドとグループのメンバーを取得する' do
      create_list(:friendship, 10, requesting_user: @current_user)
      group = create(:group)
      create_list(:member, 10, group: group)
      create(:member, group: group, user: @current_user)

      get "/api/groups/#{group.id}/friends_and_members"
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json.length).to eq(20)
    end
  end
end

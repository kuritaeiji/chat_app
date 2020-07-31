class Api::MessagesController < ApplicationController
  protect_from_forgery except: [:index, :create]
  before_action :logged_in_user

  def index
    group = Group.find_by(id: params[:group_id])
    # カレントユーザーの閲覧履歴を更新
    member = group.members.where("user_id = ?", current_user.id)[0]
    member.update_attribute(:last_read_time, Time.zone.now)

    @messages = group.messages.includes(:user).last(50)

    @messages.each do |message|
      message.convert_image_to_url({}) if message.avatar.attached?
      message.user.convert_image_to_url(variant: { combine_options: {resize:"50x50^",crop:"50x50+0+0",gravity: :center} }) if message.user.avatar.attached?
    end
    if !@messages.empty?
      # 50以上のメッセージが存在するか
      @older_messages_present = !group.messages.where("id < ?", @messages[0].id).empty? ? true : false
      render 'index', formats: :json, handlers: 'jbuilder'
    else
      render json: { message: '新規メッセージはありません' }
    end
  end

  def return_new_messages #setIntervalで使う
    group = Group.find_by(id: params[:group_id])
    last_message_id = params[:last_message_id].to_i
    # カレントユーザーの閲覧履歴を更新
    member = group.members.where("user_id = ?", current_user.id)[0]
    member.update_attribute(:last_read_time, Time.zone.now)

    @messages = group.messages.includes(:user).where("id > (?) AND NOT user_id = ?", last_message_id, current_user.id)
    @messages.each do |message|
      message.convert_image_to_url({}) if message.avatar.attached?
      message.user.convert_image_to_url(variant: { combine_options: {resize:"50x50^",crop:"50x50+0+0",gravity: :center} }) if message.user.avatar.attached?
    end
    if !@messages.empty?
      render 'return_new_messages', formats: :json, handlers: 'jbuilder'
    else
      render json: { message: '新規メッセージはありません' }
    end
  end

  def return_older_messages #さらに表示で使う
    group = Group.find_by(id: params[:group_id])
    first_message_id = params[:first_message_id].to_i

    @messages = group.messages.includes(:user).where("id < ?", first_message_id).last(50)

    @messages.each do |message|
      message.convert_image_to_url({}) if message.avatar.attached?
      message.user.convert_image_to_url(variant: { combine_options: {resize:"50x50^",crop:"50x50+0+0",gravity: :center} }) if message.user.avatar.attached?
    end
    if !@messages.empty?
      # さらに古いメッセージが存在するか
      @older_messages_present = !group.messages.where("id < ?", @messages[0].id).empty? ? true : false
      render 'index', formats: :json, handlers: 'jbuilder'
    else
      render json: { message: 'メッセージはありません' }
    end
  end

  def create
    group = Group.find_by(id: params[:group_id])
    @message = Message.new(content: params[:message][:content], group_id: group.id, user_id: current_user.id)
    if @message.save
      @message = group.messages.includes(:user).where("user_id = ?", current_user.id).last
      @message.attach_image(params[:message][:avatar])
      @message.convert_image_to_url(variant: { combine_options: {resize:"100x100^",crop:"100x100+0+0",gravity: :center} }) if @message.avatar.attached?
      render 'create', formats: :json, handlers: 'jbuilder'
    else
      render 'error', formats: :json, handlers: 'jbuilder'
    end
  end

  def return_unread_messages_count
    groups = current_user.groups
    unread_messages_count = groups.inject(0) do |result, group|
      group.set_unread_messages_count_by_group(current_user)
      result + group.unread_messages_count_by_group
    end
    render json: { unread_messages_count: unread_messages_count }
  end

  private
    def message_params
      params.require(:message).permit(:content)
    end
end

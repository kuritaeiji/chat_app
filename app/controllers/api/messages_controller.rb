class Api::MessagesController < ApplicationController
  protect_from_forgery except: [:index, :create]
  before_action :logged_in_user

  def index
    group = Group.find_by(id: params[:group_id])
    last_message_id = params[:last_message_id].to_i
    # カレントユーザーの閲覧履歴を更新
    member = group.members.where("user_id = ?", current_user.id)[0]
    member.update_attribute(:last_read_time, Time.zone.now)
    @messages = group.messages.includes(:user).where("id > ?", last_message_id)
    @messages.each do |message|
      message.convert_image_to_url(variant: { combine_options: {resize:"100x100^",crop:"100x100+0+0",gravity: :center} }) if message.avatar.attached?
    end
    if !@messages.empty?
      render 'index', formats: :json, handlers: 'jbuilder'
    else
      render json: { message: '新規メッセージはありません' }
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

  private
    def message_params
      params.require(:message).permit(:content)
    end
end

class Api::GroupsController < ApplicationController
  # protect_from_forgery except: [:index, :show, :create, :update, :destroy]
  before_action :logged_in_user

  def index
    @groups = current_user.groups # あとでmessageの新しい順にする。
    if !@groups.empty?
      @groups.each do |group|
        group.convert_image_to_url(variant: { combine_options: {resize:"100x100^",crop:"100x100+0+0",gravity: :center} }) if group.avatar.attached?
      end
      render 'index', formats: :json, handlers: 'jbuilder'
    else
      render json: { message: 'error' }
    end
  end

  def show
    @group = Group.find_by(id: params[:id])
    if @group
      @group.convert_image_to_url(variant: { combine_options: {resize:"100x100^",crop:"100x100+0+0",gravity: :center} }) if @group.avatar.attached?
      render 'show', formats: :json, handlers: 'jbuilder'
    else
      render json: { message: 'error' }
    end
  end

  def create # 普通にグループを作る時は三人以上のグループのみをjs側で実装
    other_user_id = params[:group][:user_ids].detect{ |user_id| user_id != current_user.id.to_s}
    if params[:group][:user_ids].length == 2 && current_user.groups.length > 0 && current_user.groups.any? { |group| group.members.map(&:user_id).detect{ |user_id| current_user.id != user_id }.to_s == other_user_id }
      group = current_user.groups.detect { |group| group.members.map(&:user_id).detect { |user_id| current_user.id != user_id }.to_s == other_user_id }
      render json: { group_id: group.id } # ホーム画面から会話ボタンを押した時すでにグループがあるなら処理を終わらせ、まだないならグループを作る
    else
      @group = Group.new(group_params)
      if @group.save
        @group.attach_image(params[:group][:avatar])
        render json: { group_id: @group.id }
      else
        render 'error', formats: :json, handlers: 'jbuilder'
      end
    end
  end

  def destroy
    group = Group.find_by(id: params[:id]).destroy
    render json: { message: 'success' }
  end

  def update
    @group = Group.find_by(id: params[:id])
    if @group.update(group_params) && @group.attach_image(params[:group][:avatar])
      render json: { message: 'success' }
    else
      render 'error', formats: :json, handlers: 'jbuilder'
    end
  end

  def leave_the_group
    member = current_user.members.detect { |member| member.group_id = params[:id] }
    member.destroy
    render json: { message: 'success' }
  end

  private
    def group_params
      params.require(:group).permit(:name, user_ids: [])
    end
end
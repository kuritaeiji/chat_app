class Api::GroupsController < ApplicationController
  protect_from_forgery except: [:index, :show, :create, :update, :destroy]
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

  def create
    @group = Group.new(group_params)
    if @group.save
      @group.attach_image(params[:group][:avatar])
      render json: { message: 'success' }
    else
      render 'error', formats: :json, handlers: 'jbuilder'
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

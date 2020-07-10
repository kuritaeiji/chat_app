class Api::FriendshipsController < ApplicationController
  # protect_from_forgery except: [:index, :users_applying_for_friends_to_me, :create, :approve, :destroy_friend]
  before_action :logged_in_user

  def index
    user = User.find_by(id: params[:user_id])
    @friends = user.friends
    if (@friends.length > 0)
      @friends.each do |friend|
        friend.convert_image_to_url(variant: { combine_options: {resize:"100x100^",crop:"100x100+0+0",gravity: :center} }) if friend.avatar.attached?
      end
      render 'index', formats: :json, handlers: 'jbuilder'
    else
      render json: { message: '友達がいません' }
    end
  end

  def users_applying_for_friends_to_me
    user = User.find_by(id: params[:user_id])
    @users_applying_for_friends_to_me = user.users_applying_for_friends_to_me
    if (@users_applying_for_friends_to_me.length > 0)
      @users_applying_for_friends_to_me.each do |user|
        user.convert_image_to_url(variant: { combine_options: {resize:"100x100^",crop:"100x100+0+0",gravity: :center} }) if user.avatar.attached?
      end
      render 'users_applying_for_friends_to_me', formats: :json, handlers: 'jbuilder'
    else
      render json: { message: '申請してきているユーザーはいません' }
    end
  end

  def users_count_applying_for_friends_to_me
    user = User.find_by(id: params[:user_id])
    count = user.users_count_applying_for_friends_to_me
    render json: { count: count }
  end

  def create # 友達申請するアクション
    requesting_user = User.find_by(id: params[:user_id])
    requested_user = User.find_by(id: params[:requested_user_id])
    if requesting_user.apply_for_friend_to(requested_user)
      render json: { message: '申請しました。' }
    else
      render json: { message: 'エラー' }
    end
  end

  def approve # 友達承認するアクション
    user = User.find_by(id: params[:user_id])
    requesting_user = User.find_by(id: params[:requesting_user_id])
    if user.approve_friend_from(requesting_user)
      render json: { message: '承認しました' }
    else
      render json: { message: 'エラー' }
    end
  end

  def destroy_friend
    user = User.find_by(id: params[:user_id])
    destroying_user = User.find_by(id: params[:detroying_user_id])
    user.delete_friend(destroying_user)
    render json: { message: '解除しました。' }
  end

  private
    def logged_in_user
      unless logged_in?
        render json: { message: 'ログインしてください' }
      end
    end
end
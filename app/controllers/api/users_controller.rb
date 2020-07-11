class Api::UsersController < ApplicationController
  protect_from_forgery except: [:create, :show, :update]

  def create
    @user = User.new(user_params)
    if @user.save
      @user.attach_image(params[:user][:avatar])
      @user.create_activation_token_and_digest
      UsersMailer.send_account_activation(@user).deliver_now
      render json: { message: 'success' }
    else
      render 'error', formats: :json, handlers: 'jbuilder'
    end
  end

  def show
    @user = User.find_by(id: params[:id])
    @user.convert_image_to_url(variant: { combine_options: {resize:"100x100^",crop:"100x100+0+0",gravity: :center} }) if @user.avatar.attached?
    render 'show', formats: :json, handlers: 'jbuilder'
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update(update_params)
      @user.attach_image(params[:user][:avatar])
      @user.convert_image_to_url(variant: { combine_options: {resize:"100x100^",crop:"100x100+0+0",gravity: :center} }) if @user.avatar.attached?
      render 'show', formats: :json, handlers: 'jbuilder'
    else
      render 'error', formats: :json, handlers: 'jbuilder'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :identifier_id, :description)
    end

    def update_params
      params.require(:user).permit(:name, :description)
    end
end

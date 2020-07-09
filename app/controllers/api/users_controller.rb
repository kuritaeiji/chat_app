class Api::UsersController < ApplicationController
  # protect_from_forgery except: [:create, :show]

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
    @user.encode_image if @user.avatar.attached?
    render 'show', formats: :json, handlers: 'jbuilder'
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :identifier_id, :description)
    end
end

class Api::UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      @user.attach_image(params.require(:user).permit(:avatar))
      @user.create_activation_token_and_digest
      UsersMailer.send_account_activation(@user).deliver_now
      render json: { message: 'success' }
    else
      render 'error', formats: :json, handlers: 'jbuilder'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :identifier_id, :description)
    end
end

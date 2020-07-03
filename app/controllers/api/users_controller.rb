class Api::UsersController < ApplicationController
  protect_from_forgery except: [:create]

  def create
    @user = User.new(user_params)
    if @user.save
      @user.attach_image(params.require(:user).permit(:avatar))
      head :no_content
    else
      render 'error', formats: :json, handlers: 'jbuilder'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :identifier_id, :description)
    end
end

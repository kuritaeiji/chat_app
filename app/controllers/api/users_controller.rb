class Api::UsersController < ApplicationController
  protect_from_forgery except: [:create]

  def create
    user = User.new(user_params)
    binding.pry
    if user.save
      head :no_content
    else
      @object = user
      render 'error', format: 'json', handlers: 'jbuilder'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :identifier_id)
    end
end

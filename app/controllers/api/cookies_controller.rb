class Api::CookiesController < ApplicationController
  # protect_from_forgery except: [:create, :destroy]
  def create
    @user = User.find_by(email: cookie_params[:email])
    if @user && @user.authenticate(cookie_params[:password]) && @user.activated
      login(@user) unless logged_in?
      render json: { message: 'success' }
    elsif @user && !@user.activated
      render json: { error_message: 'アカウントが有効化されていません' }
    else
      render json: { error_message: 'メールアドレスもしくはパスワードが間違っています。' }
    end
  end

  def destroy
    cookies.delete(:user_id)
    render json: { message: 'success' }
  end

  private
    def cookie_params
      params.require(:cookie).permit(:email, :password)
    end
end

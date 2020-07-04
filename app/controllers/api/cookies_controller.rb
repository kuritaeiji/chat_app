class Api::CookiesController < ApplicationController
  # protect_from_forgery except: [:create]
  def create
    user = User.find_by(email: cookie_params[:email])
    if user.authenticate(cookie_params[:password])
      login(user)
      render json: 'success'
    else
      render json: { error_message: 'メールアドレスもしくはパスワードが間違っています。' }
    end
  end

  private
    def cookie_params
      params.require(:cookie).permit(:email, :password)
    end
end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Api::CookiesHelper

  private
    def logged_in_user
      unless logged_in?
        render json: { message: 'ログインしてください' }
      end
    end
end

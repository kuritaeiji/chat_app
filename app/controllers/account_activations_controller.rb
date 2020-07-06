class AccountActivationsController < ApplicationController
  def new
    user = User.find_by(email: params[:email])
    activation_token = params[:activation_token]
    if user && !user.activated && BCrypt::Password.new(user.activation_digest) == activation_token #digestとtokenの比較は逆にするとだめ
      user.update(activated: true, activated_at: Time.zone.now)
      login(user)
      redirect_to root_url
    else
      redirect_to login_url
    end
  end
end

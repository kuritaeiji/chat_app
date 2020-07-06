class AccountActivationsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    activation_token = params[:activation_token]
    if user && !user.activated && activation_token == user.activation_digest
      user.update_attributes(activated: true, activated_time: false)
      login(user)
      redirect_to root_url
    else
      redirect_to users_new_url
    end
  end
end

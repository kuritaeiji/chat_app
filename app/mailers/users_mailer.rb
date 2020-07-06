class UsersMailer < ApplicationMailer
  def send_account_activation(user)
    @user = user
    mail subject: 'アカウント有効化', to: @user.email
  end
end

require "rails_helper"

RSpec.describe UsersMailer, type: :mailer do
  describe 'send_account_activation' do
    it '正しいメールを送る' do
      user = build(:user)
      user.activation_token = SecureRandom.base64
      UsersMailer.send_account_activation(user).deliver_now
      mail = ActionMailer::Base.deliveries.last

      expect(mail.to[0]).to eq(user.email)
      expect(mail.subject).to eq('アカウント有効化')
    end
  end
end

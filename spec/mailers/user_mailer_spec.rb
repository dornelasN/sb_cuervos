require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'password_reset' do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.password_reset(user)}

    it 'renders the headers' do
      user.reset_token = User.new_token

      expect(mail.subject).to eq('Password Reset')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['noreply@sbcuervos.com'])
    end

    it 'renders the body' do
      user.reset_token = User.new_token

      expect(mail.body.encoded).to match(user.reset_token)
      expect(mail.body.encoded).to match(CGI.escape(user.email))
    end
  end
end

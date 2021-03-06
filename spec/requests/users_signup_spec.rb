require 'rails_helper'
require './spec/support/helpers'

describe 'User signup' do
  include Helpers
  it 'should re-render the sign up page if invalid information is submitted' do
    sign_up('', 'invalid@email', 'foo', 'bar')

    expect(response).to render_template('users/new')
    expect(response).to render_template('shared/_form_errors')
  end

  it 'should create a new user and login if valid information is submitted' do
    user_count_before_post = User.count

    sign_up('Test User', 'validtest@email.com', 'password', 'password')
    follow_redirect!

    expect(flash[:success]).to be_present
    expect(user_count_before_post).to be < User.count
    expect(response).to render_template(root_path)
    # checking for logout link if succesful login
    expect(response.body).to match('Log out')
    expect(response.body).not_to match('Log in')
  end
end
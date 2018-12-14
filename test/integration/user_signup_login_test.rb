require 'test_helper'

class UserSignupLoginTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:user1)
    @user.save
    @user.confirm
  end

  test 'user sign up form' do
    visit('/')

    click_link('Sign up')

    assert page.has_field?('user_name', with: '', type: 'text')
    assert page.has_field?('user_email', with: '', type: 'email')
    assert page.has_field?('user_password', with: '', type: 'password')
    assert page.has_field?('user_password_confirmation', with: '', type: 'password')
  end

  test 'not valid user sign up' do
    visit('/')

    click_link('Sign up')

    # Try to sing up with not valid info
    fill_in('user_name', with: 'us')
    fill_in('user_email', with: 'user@example.com')
    fill_in('user_password', with: 'password')
    fill_in('user_password_confirmation', with: 'passwrd')

    assert_no_difference 'User.count' do
      click_button('Sign up')
    end

    assert page.has_css?('form[action="/signup"]')
    assert page.has_css?('div#error_explanation')
    assert page.has_css?('div.field_with_errors')
  end

  test 'valid user sign up with confirmation' do
    visit('/')

    click_link('Sign up')

    # Try to sing up with not valid info
    fill_in('user_name', with: 'user')
    fill_in('user_email', with: 'user@example.com')
    fill_in('user_password', with: 'password')
    fill_in('user_password_confirmation', with: 'password')

    # Assert user is saved
      assert_difference 'User.count', 1 do
      assert_difference 'ActionMailer::Base.deliveries.count', 1 do
        click_button('Sign up')
      end
    end

    assert page.has_content?("A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.")

    # Verify confirmation mail
    new_user = User.find_by!(email: 'user@example.com')
    confirmation_mail = ActionMailer::Base.deliveries.first.decoded
    confirmation_token = new_user.confirmation_token
    assert confirmation_mail.include?(confirmation_token)

    # Confirm user
    assert_not new_user.confirmed?
    visit("/users/confirmation?confirmation_token=#{confirmation_token}")
    new_user.reload
    assert new_user.confirmed?
  end

  test 'user log in and log out' do
    visit('/')

    click_link('Log in')

    fill_in('user_email', with: 'user1@example.com')
    fill_in('user_password', with: 'password')
    click_button('Log in')

    assert page.find_by_id('navbar-user-name').has_content?('user1')
    assert page.has_content?('Signed in successfully.')

    click_link('navbarDropdown')
    click_link('Log out')

    assert page.has_content?('Signed out successfully.')
  end

  test 'user settings' do
    sign_in @user

    visit('/')

    click_link('navbarDropdown')
    click_link('Settings')

    fill_in('user_name', with: 'Jason')
    fill_in('user_current_password', with: 'password')
    click_button('Update')

    assert page.find_by_id('navbar-user-name').has_content?('Jason')
  end
end

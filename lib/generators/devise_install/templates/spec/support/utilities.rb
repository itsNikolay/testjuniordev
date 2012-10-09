include ApplicationHelper

def sign_in(user)
  visit "/users/sign_in"
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
# Sign in when not using Capybara as well.
#cookies[:remember_token] = user.remember_token
end

include Devise::TestHelpers

# gives us the login_as(@user) method when request object is not present
include Warden::Test::Helpers
Warden.test_mode!

# Will run the given code as the user passed in
def as_user(user=nil, &block)
  current_user = user || Factory.create(:user)
  if request.present?
    sign_in(current_user)
  else
    login_as(current_user, :scope => :user)
  end
  block.call if block.present?
  return self
end

def as_admin(user=nil, &block)
  current_user = user || Factory.create(:admin)
  if request.present?
    sign_in(current_user)
  else
    login_as(current_user, :scope => :user)
  end
  block.call if block.present?
  return self
end
require "spec_helper"

describe "user registration" do

  let(:user) { FactoryGirl.create(:user) }
  subject { user }

  it "allows new users to log in" do
    sign_in user
    page.should have_content("Signed in successfully.")
  end

  it "allow new users to sign up" do
    visit "/users/sign_up"
    fill_in "Email",    with: "example@email.com"
    fill_in "Password", with: "secret"
    fill_in "Password confirmation", with: "secret"
    click_button "Sign up"
    #save_and_open_page
    page.should have_content("Welcome! You have signed up successfully.")
  end

   it "allow new users to edit its own profile" do
    user = FactoryGirl.create(:user)
    sign_in user
    visit "/users/edit"
    fill_in "Email",    with: user.email
    fill_in "Password", with: 'password'
    fill_in "Password confirmation", with: 'password'
    fill_in "Current password", with: user.password
    click_button "Update"
    page.should have_content("You updated your account successfully.")
  end

end
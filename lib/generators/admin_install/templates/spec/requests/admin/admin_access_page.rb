require "spec_helper"

describe "user registration" do

  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }

  it "only admins is allowed to visit a admin lounge" do
    as_user(user)
    visit '/admin'
    current_path.should == root_path
    page.has_content?('This page is allowed for admin')
  end

  it "admins is allowed to visit a admin lounge" do
    as_admin(admin)
    visit '/admin'
    current_path.should == '/admin'
    page.has_content?('Admin::Base#index')
  end

end
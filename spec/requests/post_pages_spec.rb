require 'spec_helper'

describe "Post pages" do

  let(:user) { FactoryGirl.create(:user) }
  let(:anotherUser) { FactoryGirl.create(:user, email: "example@example.com") }
  let(:post) { FactoryGirl.create(:post) }
  let(:yesterdayPost) { FactoryGirl.create(:post, title: "Title for post 2", created_at: Date.yesterday) }
  let(:anoterUserPost) { FactoryGirl.create(:post, user: anotherUser) }

  before(:each) { as_user(user)}

  describe "user post creation" do
    before { visit new_post_path }

    describe "with invalid information" do

      it "should not create a post" do
        expect { click_button "Create Post" }.not_to change(Post, :count)
      end

      describe "error messages" do
        before { click_button "Create Post" }
        it { should have_content('error') }
      end

      it "has to log in before create a post" do
        logout
        visit new_post_path
        page.should have_content('You need to sign in or sign up before continuing.')
      end

    end

    describe "with valid information" do

      it "should create a post" do
        #save_and_open_page
        fill_in "Title", with: post.title
        fill_in "post_text", with: post.text
        check('Published')
        expect { click_button "Create Post" }.to change(Post, :count).by(1)
        page.has_content?('Post was successfully created.')
      end

      it "should have information about publisher of the post" do
        visit root_path
        page.has_content?(post.user.email)
      end
    end
  end

  describe "post edit" do

    it "should edit a post" do
      edit_title= "Edited title for the post."
      visit edit_post_path(post)
      fill_in "Title", with: edit_title
      click_button "Update Post"
      page.has_content?('Post was successfully updated.')
    end
  end


  describe "post destruction" do
    before { FactoryGirl.create(:post) }
    before { visit posts_path }

    it "should delete a micropost" do
      expect { click_link "Destroy" }.to change(Post, :count).by(-1)
    end
  end

  it "has just today posts on main page" do
    visit root_path
    page.has_content?(post.title)
    page.has_no_content?(yesterdayPost.title)
  end

  describe "permissons for autorized users" do
    it "can be edit by its owner publisher of the post" do
      as_user(anotherUser)
      visit edit_post_path(post)
      page.has_content?("The Post can edit only its own publisher.")
      current_path.should == root_path
    end
  end

  describe "myposts page" do
    it "should have listing of current user posts" do
      visit myposts_path
      page.has_content?(post.title)
      page.has_no_content?(anoterUserPost.title)
    end
  end


end
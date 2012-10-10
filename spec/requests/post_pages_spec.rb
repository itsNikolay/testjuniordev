require 'spec_helper'

describe "Post pages" do

  let(:user) { FactoryGirl.create(:user) }
  let(:anotheruser) { FactoryGirl.create(:anotheruser) }
  let(:post) { FactoryGirl.create(:post) }
  let(:yesterdaypost) { FactoryGirl.create(:yesterdaypost) }
  let(:unpublishedpost) { FactoryGirl.create(:unpublishedpost) }
  let(:post2) { FactoryGirl.create(:post2) }

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
    describe "should not delete published post" do
      before { FactoryGirl.create(:post) }
      before { visit posts_path }
      it "should not delete a post" do
        expect { click_link "Destroy" }.to change(Post, :count).by(0)
      end
    end

    describe "should delete a unpublished post" do
      before { FactoryGirl.create(:unpublishedpost) }
      before { visit posts_path }
      it "should delete a post" do
        expect { click_link "Destroy" }.to change(Post, :count).by(-1)
      end
    end
  end

  describe "today posts" do
    before { FactoryGirl.create(:post) }
    before { FactoryGirl.create(:yesterdaypost) }
    before { visit root_path }
    it "has just today posts on main page" do
      page.should have_content(post.title)
      page.should_not have_content(yesterdaypost.title)
    end
  end

  describe "permissons for autorized users" do
    it "can be edit by its owner publisher of the post" do
      as_user(anotheruser)
      visit edit_post_path(post)
      page.has_content?("The Post can edit only its own publisher.")
      current_path.should == root_path
    end
  end

  describe "myposts page" do
    before { FactoryGirl.create(:post2) }
    before { FactoryGirl.create(:post) }
    it "should have listing of current user posts" do
      visit myposts_path
      page.has_content?(post.title)
      page.should_not have_content(post2.title)

    end
  end

  describe "published posts" do
    before { FactoryGirl.create(:unpublishedpost) }
    it "should not allow edit published value during editing and publish after editing" do
      visit edit_post_path(unpublishedpost)
      page.should have_no_selector(:published)
      click_button "Update Post"
      page.should have_content(unpublishedpost.title)
      page.should have_content("true")
    end
  end

  describe "mark unpublished posts to published" do
    before { FactoryGirl.create(:unpublishedpost) }
    it "should have checkbox for publish post" do
      visit myposts_path
      check 'post_ids_'
      click_on "Mark as Publish"
      page.should have_content "true"
    end
  end

  describe "act_as_taggable_on" do
    before { FactoryGirl.create(:post, tag_list: "good, better, thebest")}
    before { FactoryGirl.create(:post2, tag_list: "good, better, thebest")}
    before { FactoryGirl.create(:yesterdaypost, tag_list: "another, and, other")}
    it "should add tags to the post" do
      visit new_post_path
      fill_in "Title", with: post.title
      fill_in "Text", with: post.text
      fill_in "post_tag_list", with: "good, better, thebest"
      click_on "Create Post"
      page.should have_content("Post was successfully created.")
      page.should have_content("good")
      page.should have_content("better")
      page.should have_content("thebest")
    end

    it "should select by tag" do
      visit tag_path("good")
      page.should have_content(post.title)
      page.should have_content(post2.title)
      page.should_not have_content(yesterdaypost.title)
    end

    it "should have tags cloud" do
      visit root_path
      page.should have_content("good")
      page.should have_content("better")
      page.should have_content("thebest")
      page.should have_content("another")
      page.should have_content("and")
      page.should have_content("other")
    end

  end
end
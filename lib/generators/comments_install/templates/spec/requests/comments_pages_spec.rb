require 'spec_helper'

describe "Comments pages" do

  let(:user) { FactoryGirl.create(:user, email: "commentstest@example.com") }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:post) { FactoryGirl.create(:post) }
  let(:comment) { FactoryGirl.create(:comment) }
  let(:comment2) { FactoryGirl.create(:comment2) }

  before(:each) { as_admin(admin)}

  describe "create comment" do
    before { visit post_path(post) }

    it "should not create blank comment" do
       page.has_content?(post.title)
      expect { click_button "Create Comment" }.not_to change(Comment, :count)
    end

    it "should create comment" do
      fill_in "Comment", with: comment.content
      expect { click_button "Create Comment" }.to change(Comment, :count).by(1)
      page.has_content?('Comment created.')
      page.has_content?(comment.content)
    end

    it "should have lising of the comments" do
      logout
      as_user(user)
      visit post_path(post)
      fill_in "Comment", with: comment2.content
      expect { click_button "Create Comment" }.to change(Comment, :count).by(1)
      page.has_content?('Comment created.')
      page.has_content?(comment2.content)
      page.has_content?(comment.content)
    end
  end
end
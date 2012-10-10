require 'spec_helper'

describe "Comments pages" do

  let(:user) { FactoryGirl.create(:user) }
  let(:anotherUser) { FactoryGirl.create(:user, email: "commentstest@example.com") }
  let(:post) { FactoryGirl.create(:post) }
  let(:comment) { FactoryGirl.create(:comment) }
  let(:anotherComment) { FactoryGirl.create(:comment, content: "A little another content") }

  before(:each) { as_user(user)}

  describe "create comment" do
    before { visit post_path(post) }

    it "should not create blank comment" do
      page.has_content?(post.title)
      expect { click_button "Create Comment" }.not_to change(Comment, :count)
    end

    it "should create comment" do
      fill_in "comment_content", with: comment.content
      expect { click_button "Create Comment" }.to change(Comment, :count).by(1)
      page.has_content?('Comment created.')
      page.has_content?(comment.content)
    end

    it "should have lising of the comments" do
      logout
      as_user(anotherUser)
      visit post_path(post)
      fill_in "comment_content", with: anotherComment.content
      expect { click_button "Create Comment" }.to change(Comment, :count).by(1)
      page.has_content?('Comment created.')
      page.has_content?(anotherComment.content)
      page.has_content?(comment.content)
    end
  end

  describe "edit comment" do
    before { visit post_path(post) }

    it "should not create blank comment" do
      fill_in "comment_content", with: ""
      expect { click_button "Create Comment" }.not_to change(Comment, :count)
    end

    it "should edit comment" do
      someContent = "Some edited content for comment."
      fill_in "comment_content", with: someContent
      expect { click_button "Create Comment" }.to change(Comment, :count).by(1)
      page.has_content?('Comment created.')
      page.has_content?(someContent)
    end

    it "should not allow to edit the comment another user" do
      logout
      as_user(anotherUser)
      visit edit_post_comment_path(post, comment)
      page.has_content?("Editing not your comment is allowed only for the comment publisher.")
    end
  end
end
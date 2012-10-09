require 'spec_helper'

describe "Post pages" do


  let(:post) { FactoryGirl.create(:post) }
  let(:unpublished_post) { FactoryGirl.create(:unpublished_post) }

  describe "a public posts" do

    it "should show just a published posts" do
      visit posts_path
      page.has_content?(post.title)
      page.has_no_content?(unpublished_post.title)
    end

    it "published posts must be shown" do
      visit post_path(post)
      page.has_content?(post.title)
    end

    it "should not show unpublished_post" do
      visit post_path(unpublished_post)
      page.has_content?('Post is not exist or unpublished yet.')
      current_path.should == posts_path
    end
  end
end

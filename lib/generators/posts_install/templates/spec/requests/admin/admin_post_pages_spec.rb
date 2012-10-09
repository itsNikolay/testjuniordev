require 'spec_helper'

describe "Post pages" do

  let(:admin) { FactoryGirl.create(:admin) }
  let(:post) { FactoryGirl.create(:post) }

  before(:each) { as_admin(admin)}

  describe "admin post creation" do
    before { visit new_admin_post_path }

    describe "with invalid information" do

      it "should not create a post" do
        expect { click_button "Create Post" }.not_to change(Post, :count)
      end

      describe "error messages" do
        before { click_button "Create Post" }
        it { should have_content('error') }
      end

    end

    describe "with valid information" do

      it "should create a post" do
        #save_and_open_page
        fill_in "Title", with: post.title
        fill_in "Slug", with: "uniq good slug"
        fill_in "Description", with: post.description
        fill_in "post_text", with: post.text
        attach_file('Avatar', "#{Rails.root}" + '/spec/hamster.jpg')
        check('Published')
        expect { click_button "Create Post" }.to change(Post, :count).by(1)
        page.has_content?('Post was successfully created.')
      end
    end
  end

  describe "post edit" do

    it "should edit a post" do
      edit_slug = "uniq good slug2"
      visit edit_admin_post_path(post)
      fill_in "Slug", with: edit_slug
      click_button "Update Post"
      page.has_content?('Post was successfully updated.')
      page.has_content?(edit_slug.parameterize)
    end
end


describe "post destruction" do
  before { FactoryGirl.create(:post) }
  before { visit admin_posts_path }

  it "should delete a micropost" do
    expect { click_link "Destroy" }.to change(Post, :count).by(-1)
  end
end
end
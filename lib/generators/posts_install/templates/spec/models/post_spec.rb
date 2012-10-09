require 'spec_helper'

describe Post do

  let(:post) { FactoryGirl.create(:post) }

  before do
    @post = Post.new(title: post.title, slug: post.slug, description: post.description, text: post.text, published: post.published, avatar: post.avatar)
  end

  subject { @post }

  it { should respond_to(:title) }
  it { should respond_to(:slug) }
  it { should respond_to(:text) }
  it { should respond_to(:published) }
  it { should respond_to(:avatar) }
  it { should respond_to(:user) }

  describe "with blank content" do
    before { @post.text = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @post.title = "a" * 81 }
    it { should_not be_valid }
  end

end
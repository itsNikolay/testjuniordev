require 'spec_helper'

describe Post do

  let(:post) { FactoryGirl.create(:post) }

  before do
    @post = Post.new(title: post.title,
                     text: post.text, published: post.published, created_at: post.created_at )
  end

  after(:all) { @post.delete }

  subject { @post }

  it { should respond_to(:title) }
  it { should respond_to(:text) }
  it { should respond_to(:published) }

  describe "with blank content" do
    before { @post.text = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @post.title = "a" * 81 }
    it { should_not be_valid }
  end

end
require 'spec_helper'

describe Comment do

  let(:post) { @post = FactoryGirl.create(:post) }
  let(:comment) { FactoryGirl.build(:comment) }

  before do
    @comment = post.comments.new(content: comment.content)
  end

  subject { @comment }

  it { should respond_to(:content) }

  describe "when :content is NOT present" do
    before { @comment.content = " " }
    it { should_not be_valid }
  end

  describe "when :content is present" do
    before { @comment.content = "Lorem ipsum" }
    it { should be_valid }
  end

  describe "when :content is more 300 symbols" do
    before { @comment.content = "a" * 301 }
    it { should_not be_valid }
  end
end
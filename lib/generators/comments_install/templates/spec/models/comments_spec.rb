require 'spec_helper'

describe Comment do

  let(:user2) { FactoryGirl.create(:user, email: "example@example.com") }
  let(:post) { FactoryGirl.create(:post) }
  let(:comment) { FactoryGirl.create(:comment) }
  let(:comment2) { FactoryGirl.create(:comment2) }

  before do
    @comment = post.comments.create(content: comment.content)
    @comment.user = user2
    #@comment = Comment.new(content: comment.content)
  end

  subject { @comment }

  it { should respond_to(:content) }

  describe "with blank content" do
    before { @comment.content = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @comment.content = "a" * 1001 }
    it { should_not be_valid }
  end

end
require 'spec_helper'

describe Comment do
  before(:each) do
    @user = Factory(:user, :trusted => true)
    @user2 = Factory(:user, :email => Factory.next(:email), :trusted => true)
    @post1 = @user.posts.create(:wall_id => @user2, :body => "Foobar from user")
  end
  
  it "should create a comment give the right attributes" do
    @post1.comments.create(:content => "Foobar", :user_id => @user)
  end
  
  describe "associations" do
    before(:each) do
      @comment = @post1.comments.create(:content => "Foobar", :user_id => @user)
    end
    
    it "should have an user" do
      @comment.should respond_to(:user)
    end
    
    it "should have a commentable" do
    end
    
    it "should have the right user" do
      @comment.user_id == @user.id
      @comment.user == @user
    end
  end
  
  describe "validations" do
    before(:each) do
      @attr = { :user_id => @user, :commentable_id => @post1, :commentable_type => "Post",
                :body => "Foobar" }
    end
    
    it "should require a user_id" do
      @attr.merge(:user_id => "")
      Comment.new(@attr).should_not be_valid
    end
    
    it "should require a commentable_id" do
      @attr.merge(:commentable_id => "")
      Comment.new(@attr).should_not be_valid
    end
    
    it "should require a commentable_type" do
      @attr.merge(:commentable_type => "")
      Comment.new(@attr).should_not be_valid
    end
    
    it "should have a non-blank body" do
      @attr.merge(:body => "")
      Comment.new(@attr).should_not be_valid
    end
  end
end

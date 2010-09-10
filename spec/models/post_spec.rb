require 'spec_helper'

describe Post do
  
  describe "creating a post" do
    
    before(:each) do
      @user = Factory(:user, :trusted => true)
      @friend = Factory(:user, :email => Factory.next(:email), :trusted => true)
    end
    
    it "should not be possible to create a post with an emtpy body" do
      @user.posts.create(:wall_id => @friend).should_not be_valid
    end

  end
end

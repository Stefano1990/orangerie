require 'spec_helper'

describe CommentsController do
  render_views
  
  describe "wall post comments" do
    
    before(:each) do
      @user = Factory(:user, :trusted => true)
      sign_in @user
      @user2 = Factory(:user, :email => Factory.next(:email), :trusted => true)
      @user3 = Factory(:user, :email => Factory.next(:email), :trusted => true)
      
      @post1 = @user.posts.create(:wall_id => @user2, :body => "Foobar from user")
      @post2 = @user3.posts.create(:wall_id => @user2, :body => "Foobar from user3")
  
    end
    
    describe "create 'post'" do
      describe "failure" do
        it "should not create a comment if the user is not logged in" do
          lambda do
            sign_out @user
            post :create, :user_id => @user3.id, :post_id => @post2.id
            response.should_not be_success
          end.should_not change(Comment, :count)
        end
        
        it "should not create a comment if the owner of the wall is not a friend" do
          lambda do
            post :create, :user_id => @user3.id, :post_id => @post2.id
            response.should_not be_success
          end.should_not change(Comment, :count)
        end
        
        it "should not create a comment if the user is not trusted" do
          lambda do
            make_user_untrusted(@user)
            post :create, :user_id => @user.id, :post_id => @post2.id
            response.should_not be_success
          end.should_not change(Comment, :count)
        end
      end
      
      describe "success" do
      end
    end
  end
  
  def make_user_untrusted(user)
    sign_out user
    user.trusted = false
    user.save
    sign_in user
  end
  
  def become_friends(user, friend)
    Connection.connect(user, friend)
  end
  
end

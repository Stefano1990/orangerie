require 'spec_helper'

describe PostsController do
  render_views
  
  describe "wall posts" do
    
    before(:each) do
      @user = Factory(:user, :trusted => true)
      sign_in @user
      @user2 = Factory(:user, :email => Factory.next(:email), :trusted => true)
      @user3 = Factory(:user, :email => Factory.next(:email), :trusted => true)
      @atts = { :wall_id => @user2, :body => "foobar" }
    end
    
    describe "create 'post' action" do
      describe "failure" do
        describe "for not trusted users" do
      
          it "should not make an own wall post if the user is not trusted" do
            make_user_untrusted(@user)
            lambda do
              post :create, :post => @atts.merge(:wall_id => @user)
            end.should_not change(Post, :count)
          end
      
          it "should not make an somebodys wall post if the user is not trusted" do
            make_user_untrusted(@user)
            lambda do
              post :create, :post => @atts.merge(:wall_id => @user)
            end.should_not change(Post, :count)
          end
        end
      
        describe "for 'not friend' users" do      
          it "should not make a post on somebodys wall if they are not friends" do
            lambda do
              post :create, :post => @atts
            end.should_not change(Post, :count)
          end        
        end
      end

    
      describe "success" do      
        it "should make a post on own wall" do
          lambda do
            post :create, :post => @atts.merge(:wall_id => @user)
          end.should change(Post, :count).by(1)
        end
      
        it "should make a post on a friends wall" do
          become_friends(@user, @user2)
          lambda do
            post :create, :post => @atts.merge(:wall_id => @user2)
          end.should change(Post, :count).by(1)
        end
      end
    end
  
  
    describe "delete 'destroy'" do
      
      before(:each) do
        @post1 = @user.posts.create(:wall_id => @user2, :body => "foobar")
        @post2 = @user.posts.create(:wall_id => @user, :body => "Foobar2")
      end
      describe "failure" do
        it "should not delete a wall post if the user is not the owner of the profile or an admin" do
          #lambda do
          #  delete :destroy, :id => @post1
          #  flash[:error] =~ /not allowed/i
          #  response.should redirect_to(user_path(@user)) 
          #end.should_not change(Post, :count)
        end
        
        it "should not delete a wall post if the user is not trusted" do
          make_user_untrusted(@user)
          lambda do
            delete :destroy, :id => @post2
            flash[:error] =~ /not allowed/i
            response.should redirect_to(trusted_user_path(@user))
          end.should_not change(Post, :count)
        end
      end
      
      describe "success" do
        it "should delete a wall post if the user is the owner or and admin" do
          lambda do
            delete :destroy, :id => @post2
            flash[:success] =~ /Post deleted/i
            response.should redirect_to(user_path(@user))
          end.should change(Post, :count).by(-1)
        end
        
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

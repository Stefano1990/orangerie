require 'spec_helper'

describe ConnectionsController do
  render_views
  
  before(:each) do
    @user = Factory(:user)
    @friend = Factory(:user, :email => Factory.next(:email))
    @bob = Factory(:user, :email => Factory.next(:email))
    sign_in @user
  end
  
  describe "for trusted users" do
    it "should protect the create page" do
      sign_out @user
      post :create
      response.should redirect_to(new_user_session_path)
    end

    it "should create a new connection request" do
      lambda do
        post :create, :contact_id => @user, :user_id => @friend 
        response.should redirect_to(@friend)
      end.should change(Connection, :count).by(2)
    end

    describe "with existing connection" do
  
      before(:each) do
        Connection.request(@user, @friend)
        @connection = Connection.conn(@user, @friend)
      end
  
      it "should get the edit page" do
        get :edit, :id => @connection
        response.should be_success 
      end
  
      it "should require the right user" do
        sign_in @bob
        get :edit, :id => @connection
        response.should redirect_to(user_path(@bob))
      end
    
      it "should accept a request" do
      
        put :update, :id => @connection, :commit => "Accept" 
        Connection.find(@connection).status.should == Connection::ACCEPTED
        response.should redirect_to(user_path(@connection.contact))
      end
    
      it "should decline a request" do
        lambda do
          put :update, :id => @connection, :commit => "Decline"
          response.should redirect_to(user_path(@user))
        end.should change(Connection, :count).by(-2)
      end
    
      it "should end a connection" do
        lambda do
          delete :destroy, :id => @connection
          response.should redirect_to(user_path(@user))
        end.should change(Connection, :count).by(-2)
      end
    end
  end
  
end

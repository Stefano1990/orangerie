require 'spec_helper'

describe Connection do
  
  before(:each) do
    @user = Factory(:user)
    @user2 = Factory(:user, :email => Factory.next(:email))
  end
  
  describe "class methods" do
    
    it "should create a request" do
      Connection.request(@user, @user2)
      status(@user, @user2).should == Connection::REQUESTED
      status(@user2, @user).should == Connection::PENDING
    end
    
    it "should accept a request" do
      Connection.request(@user, @user2)
      Connection.accept(@user2, @user)
      status(@user, @user2).should == Connection::ACCEPTED
      status(@user2, @user).should == Connection::ACCEPTED
    end
    
    it "should break up a connection" do
      Connection.request(@user, @user2)
      Connection.breakup(@user, @user2)
      Connection.exists?(@user, @user2).should be_false
    end
  end
  
  describe "instance methods" do
    before(:each) do
      Connection.request(@user, @user2)
      @connection = Connection.conn(@user, @user2)
    end
    
    it "should accept a request" do
      @connection.accept
    end
    
    it "should break up a connection" do
      @connection.breakup
      Connection.exists?(@user, @user2).should be_false
    end
  end
  
  def status(user, conn)
    Connection.conn(user, conn).status
  end
end

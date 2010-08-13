require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { :name => "Mr. Foobar", 
              :email  => "user@example.com", 
              :password => "foobar",
              :password_confirmation => "foobar"
            }
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end
  
  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com THE_USER_at_foo.bar.org first.lastfoo.jp examp.user@foo]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate email addresses" do
    # Put a user with given email address into the database
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "should reject emails identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end
    
    it "should reject long passwords" do
      long = "a" * 51
      User.new(@attr.merge(:password => long, :password_confirmation => long)).
        should_not be_valid
    end
  end
  
  describe "user infos" do
    
    before(:each) do
      @infos = { :age => "23",
                 :weight => "82", 
                 :hair_color => "Green", 
                 :appearance => "Thin", 
                 :about_us => "We like FOO BARS!" }
      @user = User.create!(@attr)
      @user.user_infos.edit(@infos)
    end
  end
  
  describe "relationships" do
     
    before(:each) do
      @user = Factory(:user)
      @user2 = Factory(:user, :email => Factory.next(:email))
    end
    
    it "should have friends" do
      @user.should respond_to(:friends)
    end
    
    it "should have a become_friend! method" do
      @user.should respond_to(:become_friend!)
    end
    
    it "should have a accept_request method" do
      @user.should respond_to(:accept_request)
    end
    
    it "should send a friend request" do
      @user.become_friend!(@user2)
      @user.friends.include?(@user2).should be_true
    end
  end
end

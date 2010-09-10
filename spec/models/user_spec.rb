require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { :name => "Mr. Foobar", 
              :email  => "user@example.com", 
              :password => "foobar",
              :password_confirmation => "foobar"
            }
    @user = Factory(:user)
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
  
  
  describe "connections(?)" do
     before(:each) do
       @user.trusted = true
       @friend = Factory(:user, :email => Factory.next(:email), :trusted => true)
     end
     
     it "should have requested contacts" do
       Connection.request(@user, @friend)
       @user.requested_contacts.should_not be_empty
     end
     
     it "should have contacts" do
       Connection.connect(@friend, @user)
       #@user.contacts.should == @friend
       #@friend.contacts.should == @user
     end
     
     describe "common contacts" do
       
       before(:each) do
         @bob = Factory(:user, :email => Factory.next(:email), :trusted => true)
         Connection.connect(@user, @friend)
         Connection.connect(@friend, @bob)
       end
       
       it "should have common contacts with someone" do
         common_contacts = @user.common_contacts_with(@bob)
         common_contacts.size.should == 1
         common_contacts.should == [@friend]
       end
       
       it "should exclude not trusted users from list" do
         @bob.trusted = false
         common_contacts = @user.common_contacts_with(@friend)
         common_contacts.should be_empty
       end
       
       it "should exclude the person being viewed" do
         Connection.connect(@user, @bob)
         @user.common_contacts_with(@bob).should_not include(@bob)
       end
       
       it "should excluded the person viewing" do
         Connection.connect(@user, @bob)
         @user.common_contacts_with(@bob).should_not include(@user)
       end
     end
  end
end

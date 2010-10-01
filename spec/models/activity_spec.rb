require 'spec_helper'
describe Activity do
  before(:each) do
    @attr = { :item_id => 1, 
              :item_type  => "Post", 
            }
    @user = Factory(:user)
  end
  
  it "should make a new activity given the right attributes" do
    Activity.create!(@attr)
  end
  
  it "should require item id" do
    no_item_id = Activity.new(@attr.merge(:item_id => ""))
    no_item_id.should_not be_valid
  end

  it "should require item type" do
    no_item_type = Activity.new(@attr.merge(:item_type => ""))
    no_item_type.should_not be_valid
  end
  
  describe "creating a 'Post'" do
    
    before(:each) do
      @attr = {:body => "Foobar the body!",
               :user_id => 1,
               :wall_id => 1, 
               :deleted => false
              }
    end
    
    it "should create a new activity" do
      lambda do
        @post = Post.create!(@attr)
      end.should change(Activity, :count)
    end
    
    it "should have the right item_type" do
      @post = Post.create!(@attr)
      item_type = Activity.last.item_type 
      item_type.should be_equal("Post")
    end
  end
  
  describe "creating a 'Comment'" do
    
    before(:each) do
      @attr = {:body => "Foobar the body!",
               :user_id => 1,
               :commentable_id => 1,
               :commentable_type => "Post", 
               :deleted => false
              }
    end
    
    it "should create a new activity" do
      lambda do
        @comment = Comment.create!(@attr)
      end.should change(Activity, :count)
    end
    
    it "should have the right item_type" do
      @comment = Post.create!(@attr)
      item_type = Activity.last.item_type 
      item_type.should be_equal("Comment")
    end
  end
  
  describe "accepting a connection" do
    
    before(:each) do
      @attr = {:user_id => 1,
               :contact_id => 2,
               :status => 0, 
              }
    end
    
    it "should create a new activity" do
      lambda do
        @connection = Connection.create!(@attr)
      end.should change(Activity, :count)
    end
    
    it "should have the right item_type" do
      @connection = Connection.create!(@attr)
      item_type = Activity.last.item_type 
      item_type.should be_equal("Connection")
    end
  end
  
  describe "changing the profile infos" do

    before(:each) do
      @attr = {:user_id => 1,
               :sex => "Mann",
               :age_m => "20",  
               :height_m => "180", 
               :weight_m => "70", 
              }
    end
    
    it "should create a new activity" do
      lambda do
        @infos = User.infos.update_attributes!(@attr)
      end.should change(Activity, :count)
    end
    
    it "should have the right item_type" do
      @infos = User.infos.update_attributes!(@attr)
      item_type = Activity.last.item_type 
      item_type.should be_equal("Infos")
    end
  end
end

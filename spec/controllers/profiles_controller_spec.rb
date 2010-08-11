require 'spec_helper'

describe ProfilesController do
  render_views
  
  before(:each) do
    @user = Factory(:user)
  end
  
  describe "GET 'edit'" do
    
    describe "failure" do
      # user not signed in
      it "response should redirect to sign-in" do
        get :edit, :id => @user
        response.should redirect_to(new_user_session_path)
      end
    end
    
    describe "success" do
      before(:each) do
        sign_in @user
      end

      it "should be successful" do
        get :edit, :id => @user
        response.should be_success
      end

      it "should have some input fields" do
        get :edit, :id => @user
        @fields = @user.profile.find(@user).attributes
        @not_fields = ["created_at", "updated_at", "user_id", "id"]
        @fields.delete_if { |k,v|  @not_fields.include?(k)}

        @fields.each do |key, value|
          response.should have_selector("li", :id => "profile_#{key}_input")
        end
      end
      
    end
  end
  
  describe "PUT 'update'" do
    
    before(:each) do
      sign_in @user
    end
    
    describe "failure" do
      
      before(:each) do
        @inv_attr = { :age => "aaaa", :weight => "aaaaa", :height => "aaaa" }
      end
      
      it "should render the 'edit' page" do
        put :update, :id => @user, :profile => @inv_attr
        response.should render_template('edit')
      end
      
      it "should display the error(s)" do
        put :update, :id => @user, :profile => @inv_attr
        response.should have_selector("p", :content => "Bitte eine Zahl eingeben")
      end
    end
  end
  
  describe "GET 'show'" do
    
    before(:each) do
      sign_in @user
    end
  end  
end

require 'spec_helper'

describe PagesController do
  
  render_views
  
  describe "GET 'home'" do
    
    it "should be successful" do
      get :home
      response.should be_success
    end
    
    it "should display the news" do
    end
    
    
    describe "when not signed in" do
      it "should render the login form" do
        get :home
        response.should have_selector("form", :action => new_user_session_path)
      end
    end
    
    describe "when signed in" do
      
      before(:each) do
        @user = Factory(:user)
        sign_in @user
      end
      
      it "should display the profil box in the top right" do
        get :home
        response.should have_selector("span", :content => "Willkommen")
      end
    end
    
  end
end

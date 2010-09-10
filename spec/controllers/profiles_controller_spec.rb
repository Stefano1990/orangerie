require 'spec_helper'

describe ProfilesController do
  render_views
  
  before(:each) do
    @user = Factory(:user)
  end
  describe "own profile" do

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
          @fields = @user.profile.attributes
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
    
        describe "for a man" do
          before(:each) do
            @inv_attr = { :age_m => "aaaa", :weight_m => "aaaaa", :height_m => "aaaa", :sex => "Mann" }
          end
    
          it "should render the 'edit' page" do
            put :update, :id => @user, :profile => @inv_attr
            response.should render_template('edit')
          end
    
        end
      end
    end

    describe "GET 'show'" do
      describe "success" do
        before(:each) do
          sign_in @user
        end
    
        it "should render the 'show' page" do
          get :show, :id => @user
        end
    
    
      end
    end 

    describe "GET 'infos'" do
      describe "success" do
        before(:each) do
          sign_in @user
          @user2 = Factory(:user, :email => Factory.next(:email))
          
        end
    
        it "should render the 'infos' page" do
          get :infos, :id => @user
          response.should be_success
        end
    
        describe "different 'gender' behaviour" do
      
          before(:each) do
            @male_atts = {:sex => "Mann", :age_m => "23", :height_m => "180", :weight_m => "70"}
            @female_atts = { :sex => "Frau", :age_f => "23", :height_f => "180", :weight_f => "60"}
          end
      
          describe "sex is 'unknown'" do
            #it "should display 'unknown'" do
            #  @user.profile.sex = ""
            #  @user.profile.save!
            #  get :infos, :id => @user
            #  response.should have_selector("h4", :content => "Er/Sie")
            #end
          end
    
          describe "sex is 'man'" do
            it "should display 'he/him'" do
              @user.profile.update_attributes(@male_atts)
              @user.profile.save!
              get :infos, :id => @user
              response.should have_selector("h4", :content => "Er")
            end
          end
    
          describe "sex is 'woman'" do
            it "should display 'she/her'" do
              @user.profile.update_attributes(@female_atts)          
              @user.profile.save!
              get :infos, :id => @user
              response.should have_selector("h4", :content => "Sie")
            end
          end
    
          describe "sex is 'couple'" do
            it "should display 'we'" do
              @user.profile.update_attributes(@male_atts)
              @user.profile.update_attributes(@female_atts)
              @user.profile.update_attributes(:sex => "Paar")
              @user.profile.save!
              get :infos, :id => @user
              response.should have_selector("h4", :content => "Er")
              response.should have_selector("h4", :content => "Sie")
            end
          end
        end
      end
    end
  end
  
  describe "user is NOT TRUSTED" do
    before(:each) do
      @user2 = Factory(:user, :email => Factory.next(:email))
      sign_in @user
    end
    
    describe "GET 'show' of own profile" do
      it "should be successful" do
        get :show, :id => @user
        response.should be_success 
      end
      
      it "should have the profile navigation" do
        get :show, :id => @user
        response.should have_selector("div", :id => "profile-navigation")
      end
    end
    
    describe "GET 'show' of other user" do
      it "should redirect him to his own profile" do
        get :show, :id => @user2
        flash[:notice] =~ /you have to be a trusted member access this page./i
        response.should redirect_to(profile_path(@user))
      end
    end
    
    describe "GET 'infos' of other user" do
      it "should redirect him to his own profile" do
        get :infos, :id => @user2
        flash[:notice] =~ /you have to be a trusted member access this page./i
        response.should redirect_to(profile_path(@user))
      end
    end
  end
  
  describe "user IS TRUSTED" do
    before(:each) do
      @user2 = Factory(:user, :email => Factory.next(:email))
      sign_in @user
      @user.trusted = true
    end
    
    describe "GET 'show' of profile" do
      it "should be successful" do
        get :show, :id => @user
        response.should be_success
      end
          
      it "should have the profile navigation" do
        get :show, :id => @user
        response.should have_selector("div", :id => "profile-navigation")
      end
    end
    
    describe "GET 'infos' of other user" do
      it "should be successful" do
        get :infos, :id => @user
        response.should be_success
      end
      
      it "should display the infos" do
        get :infos, :id => @user2
        response.should have_selector("h4", :content => "Infos von:")
      end
    end
  end
end

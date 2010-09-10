require 'spec_helper'

describe UsersController do
  render_views
  
  before(:each) do
    @user = Factory(:user)
    @user2 = Factory(:user, :email => Factory.next(:email))
  end
  
  describe "for invalid users" do
    describe "for own profile" do
      before(:each) do
        sign_in @user
      end
      it "gets tried to get the 'show' page" do
        get :show, :id => @user
        response.should redirect_to(edit_user_path(@user))
      end
      it "gets tried to get the 'infos' page" do
        get :infos, :id => @user
        response.should redirect_to(edit_user_path(@user))
      end
      it "gets tried to get the 'friends' page" do
        get :friends, :id => @user
        response.should redirect_to(edit_user_path(@user))
      end
    end
    describe "for somebody's profile" do
      before(:each) do
        sign_in @user
      end
      it "gets tried to get the 'show' page" do
        get :show, :id => @user2
        response.should redirect_to(edit_user_path(@user))
      end
      it "gets tried to get the 'infos' page" do
        get :infos, :id => @user2
        response.should redirect_to(edit_user_path(@user))
      end
      it "gets tried to get the 'friends' page" do
        get :friends, :id => @user2
        response.should redirect_to(edit_user_path(@user))
      end
    end
  end
  describe "for valid user" do
    
    describe "for not trusted user" do
      describe "for own profile" do
        before(:each) do
          set_user_infos_m(@user)
          sign_in @user
        end
        it "should display the edit page" do
          get :edit, :id => @user
          response.should be_success
        end
        it "should display the infos page" do
          get :infos, :id => @user
          response.should be_success
        end
        it "should NOT display the wall page" do
          get :show, :id => @user
          response.should redirect_to(trusted_user_path)
        end
        it "should NOT display the friends page" do
          get :friends, :id => @user
          response.should redirect_to(trusted_user_path)
        end
      end
    end
    
    describe "for trusted user" do
      describe "for own profile" do
        before(:each) do
          set_user_infos_m(@user)
          make_trusted(@user)
          sign_in @user
        end
        describe "get 'show'" do
          it "shoule be successful" do
            get :show, :id => @user
            response.should be_success
          end
          it "should include the users name" do
            get :show, :id => @user
            response.should have_selector("h4", :content => "#{@user.name}'s Profil")
          end
        end
        
        describe "get 'infos"  do
          it "should be successful" do
            get :infos, :id => @user
            response.should be_success
          end
        end
        
        describe "get 'edit'" do
          it "should be successful" do
            get :edit, :id => @user
            response.should be_success
          end
        end
        
        describe "get 'friends" do
          it "should be successful" do
            get :friends, :id => @user
            response.should be_success
          end
        end
        
        describe "get 'fotos'" do
          it "should be successful" do
            get :fotos, :id => @user
            response.should be_success
          end
        end
        
        describe "get 'livestream'" do
          before(:each) do
            set_user_infos_f(@user2)
            make_trusted(@user2)
            Connection.connect(@user, @user2)
            @post1 = @user.posts.build(:wall_id => @user.id, :body => "Foobar")
            @post2 = @user.posts.build(:wall_id => @user2.id, :body => "Foobar")
            @post3 = @user2.posts.build(:wall_id => @user.id, :body => "Foobar")
          end
          it "should be successful" do
            get :livestream, :id => @user
            response.should be_success
          end
          it "should have a form for a new post" do
            get :livestream, :id => @user
            response.should have_selector("h3", :content => "What's on your mind?")
          end
          it "should display posts of my friends" do
            get :livestream, :id => @user
            response.should have_selector("h4", :content => @user2.name)
          end
          it "should have a commment textfield" do
            get :livestream, :id => @user
            response.should have_selector("textarea", :id => "comment_body")
          end
        end
      end
      describe "for not friends" do
        describe "for somebody else's profile" do
          before(:each) do
            set_user_infos_m(@user)
            set_user_infos_f(@user2)
            make_trusted(@user2)
            make_trusted(@user)
            sign_in @user
          end
          describe "get 'show'" do
            it "shoule be successful" do
              get :show, :id => @user2
              response.should be_success
            end
            it "should include the users name" do
              get :show, :id => @user2
              response.should have_selector("h4", :content => "#{@user2.name}'s Profil")
            end
            it "should have a button to send friend request" do
              get :show, :id => @user2
              response.should have_selector("input", :value => I18n.t('users.show.become_friends'))
            end
          end
        
          describe "get 'infos"  do
            it "should be successful" do
              get :infos, :id => @user2
              response.should be_success
            end
          end
        
          describe "get 'edit'" do
            it "should be unsuccessful" do
              get :edit, :id => @user2
              response.should redirect_to(user_path(@user2))
            end
          end
        
          describe "get 'friends" do
            it "should be successful" do
              get :friends, :id => @user2
              response.should be_success
            end
          end
        
          describe "get 'fotos'" do
            it "should be unsuccessful" do
              get :fotos, :id => @user2
              response.should redirect_to(user_path(@user2))
            end
          end
        
          describe "get 'livestream'" do
            it "should be unsuccessful" do
              get :livestream, :id => @user2
              response.should redirect_to(user_path(@user2))
            end
          end
        end
      end
    end
  end
end
def make_trusted(user)
  user.trusted = true
  user.save!
end

def set_user_infos_f(user)
  user.infos.update_attributes(:sex => "Frau", :height_f => "160", 
                                 :weight_f => "60", :age_f => "23")
end

def set_user_infos_m(user)
  user.infos.update_attributes(:sex => "Mann", :height_m => "160", 
                                 :weight_m => "60", :age_m => "23")
end
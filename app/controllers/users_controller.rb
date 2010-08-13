class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :is_trusted_or_own_profile?, :except => [:create, :update, :edit ]
  before_filter :correct_user, :except => [:show]
   
  def show
    @requests =  current_user.requested_contacts
    @user = User.find(params[:id])
  end
  
  def infos
    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(current_user.id)
  end
  
  def update_infos
    @user = User.find(current_user.id)
    @infos = @user.user_infos
    if @user.user_infos.update_attributes(params[:user_infos])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      render 'edit_infos'
    end
  end

  def accept_request
    
  end
  private
  
      def is_trusted_or_own_profile?
        unless current_user.trusted || own_profile?(Profile.find(params[:id]))
          flash[:notice] = "You have to be a trusted member to access this page."
          redirect_to profile_path(current_user)
        end
      end
      
      def own_profile?(profile)
        current_user.profile == profile
      end
      
      def correct_user
        user = User.find(params[:id])
        redirect_to(root_path) unless current_user?(user)
      end
      
      def current_user?(user)
        current_user == user
      end
end

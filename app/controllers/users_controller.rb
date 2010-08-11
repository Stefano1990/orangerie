class UsersController < ApplicationController

  before_filter :correct_user, :except => [:show]
   
  def show
    @user = User.find(params[:id])
  end
  
  def edit_infos
    @user = User.find(current_user.id)
    if @user.user_infos.blank?
      @infos = UserInfos.new
    else
      @infos = @user.user_infos
    end
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
  
  private
  
      def correct_user
        user = User.find(params[:id])
        redirect_to(root_path) unless current_user?(user)
      end
      
      def current_user?(user)
        current_user == user
      end
end

class ProfilesController < ApplicationController
  before_filter :authenticate_user!
  
  def edit
   @profile = current_user.profile.find(current_user)
  end
  
  def create
    @profile = current_user.profiles.build(params[:profile])
    if @profile.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @profile = []
      render 'pages/home'
    end
  end
  
  def update
    @profile = current_user.profile.find(current_user)
    if @profile.update_attributes(params[:profile])
      flash[:success] = "Profile updated."
      redirect_to current_user
    else
      render :edit
    end
  end
end

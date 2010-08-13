class ProfilesController < ApplicationController
  
  
  
  respond_to :html, :xml, :json, :js
  
  
  def show
    @profile = Profile.find(params[:id])
  end
  
  def infos
    @profile = Profile.find(params[:id])
    if @profile.sex.nil?
      @profile.sex = "unbekannt"
    end
  end
  
  def edit
   @profile = current_user.profile
   #respond_with(@profile)
  end
  
  def create
    @profile = current_user.profiles.build(params[:profile])
    if @profile.save!
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @profile = []
      render 'pages/home'
    end
  end
  
  def update
    @profile = current_user.profile
    if @profile.update_attributes(params[:profile])
      flash[:success] = "Profile updated."
      redirect_to current_user
    else
      render :edit
    end
  end
  
  private
    
      
      
end

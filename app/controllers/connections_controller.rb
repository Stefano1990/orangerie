class ConnectionsController < ApplicationController
  
  #before_filter :login_required, :setup
  #before_filter :authorize_view, :only => :index
  #before_filter :authorize_user, :only => [:edit, :update, :destroy]
  #before_filter :redirect_for_inactive, :only => [:edit, :update]
  before_filter :authenticate_user!
  before_filter :correct_user, :except => [:create] 
  
  # Show all the contacts for a user.
  #def index
    #@contacts = @user.contacts.paginate(:page => params[:page])
  #end
  
  def show
    # We never use this, but render "" for the bots' sake.
    render :text => ""
  end
  
  def edit
    @connection = Connection.find(params[:id])
    @contact = @connection.contact
  end
  
  def create
    @contact = User.find(params[:user_id])

    respond_to do |format|
      if Connection.request(current_user, @contact)
        flash[:notice] = 'Connection request sent!'
        format.html { redirect_to(user_path(@contact)) }
      else
        # This should only happen when people do something funky
        # like friending themselves.
        flash[:notice] = "Invalid connection"
        format.html { redirect_to(user_path(@contact)) }
      end
    end
  end

  def update
    
    respond_to do |format|
      contact = @connection.contact
      name = contact.name
      case params[:commit]
      when "Annehmen"
        @connection.accept
        flash[:notice] = raw %(Accepted connection with
                           <a href="#{user_url(contact)}">#{name}</a>)
        format.html { redirect_to(user_path(@connection.contact)) }
      when "Ablehnen"
        @connection.breakup
        flash[:notice] = "Declined connection with #{name}"
        format.html { redirect_to(user_path(current_user)) }
      end
    end
  end

  def destroy
    @connection = current_user.connections.find(params[:id])
    @connection.breakup
    
    respond_to do |format|
      flash[:success] = "Ended connection with #{@connection.contact.name}"
      format.html { redirect_to( user_path(current_user)) }
    end
  end

  private

    def setup
      # Connections have same body class as profiles.
      @body = "profile"
    end

    def authorize_view
      @user = User.find(params[:user_id])
      unless (current_user?(@user) or
              Connection.connected?(@user, current_user))
        redirect_to home_url
      end
    end
  
    # Make sure the current user is correct for this connection.
    def correct_user
      if current_user.trusted == true
        @connection = Connection.find(params[:id],
                                      :include => [:user, :contact])
        unless current_user == @connection.user
          flash[:error] = "Invalid connection."
          redirect_to user_path(current_user)
        end
      else
        flash[:error] = "You have the be a trusted member to do that."
        redirect_to trusted_user_path(current_user)
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Invalid or expired connection request"
      redirect_to user_path(current_user)
    end
    
    # Redirect if the target user is inactive.
    # Suppose Alice sends Bob a connection request, but then the admin 
    # deactivates Alice.  We don't want Bob to be able to make the connection.
    def redirect_for_inactive
      if @connection.contact.deactivated?
        flash[:error] = "Invalid connection request: user deactivated"
        redirect_to home_url
      end
    end

end
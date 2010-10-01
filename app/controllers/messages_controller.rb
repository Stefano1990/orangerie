class MessagesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :valid_user?, :only => :show
  
  def show
    @message.mark_as_read if current_user?(@message.recipient)
    respond_to do |format|
      format.html
    end
  end
  
  def new
    @user = User.find(params[:user_id])
    @message = Message.new
    @recipient = User.find(params[:user_id])

    respond_to do |format|
      format.html { render :layout => "users" }
    end
  end
  
  def index
    @user = current_user
    @messages_all = current_user.recieved_messages
    @messages = @messages_all.paginate(:page => params[:page], :per_page => params[:per_page])
    respond_to do |format|
      format.html { render :template => "messages/index", :layout => "users" }
    end
  end
  
  # GET /messages/sent
  def sent
    @user = current_user
    @messages_all = current_user.sent_messages(params[:page])
    @messages = @messages_all.paginate(:page => params[:page], :per_page => params[:per_page])
    respond_to do |format|
      format.html { render :template => "messages/index", :layout => "users" }
    end 
  end
  
  # GET /messages/trash
  def trash
    @user = current_user
    @messages = current_user.trashed_messages(params[:page])
    respond_to do |format|
      format.html { render :template => "messages/index", :layout => "users" }
    end
  end
  
  def reply
    @user = current_user
    original_message = Message.find(params[:id])
    recipient = original_message.other_user(current_user)
    @message = Message.unsafe_build(:parent_id    => original_message.id,
                                    :subject      => original_message.subject,
                                    :sender       => current_user,
                                    :recipient    => recipient)

    @recipient = not_current_user(original_message)
    respond_to do |format|
      format.html { render :action => "new", :layout => "users" }
    end
  end
  
  def create
    @message = Message.new(params[:message])
    @recipient = User.find(params[:user_id])
    @message.sender    = current_user
    @message.recipient = @recipient
    if reply?
      @message.parent = Message.find(params[:message][:parent_id])
      redirect_to home_url and return unless @message.valid_reply?
    end

    respond_to do |format|
      if !preview? and @message.save
        flash[:success] = 'Message sent!'
        format.html { redirect_to messages_url }
      else
        @preview = @message.content if preview?
        format.html { render :action => "new" }
      end
    end
  end
    
  def destroy
    @message = Message.find(params[:id])
    if @message.trash(current_user)
      flash[:success] = "Message trashed"
    else
      # This should never happen...
      flash[:error] = "Invalid action"
    end

    respond_to do |format|
      format.html { redirect_to messages_url }
    end
  end
  
  def undestroy
    @message = Message.find(params[:id])
    if @message.untrash(current_user)
      flash[:success] = "Message restored to inbox"
    else
      # This should never happen...
      flash[:error] = "Invalid action"
    end
    respond_to do |format|
      format.html { redirect_to messages_url }
    end
  end
  
  
  private
        def setup
          @body = "messages"
        end
        
        def valid_user?
          @message = Message.find(params[:id])
          unless (current_user == @message.sender or
                  current_user == @message.recipient)
            redirect_to new_user_session_path
          end
        end
        
        def current_user?(user)
          current_user == user
        end
        
        def not_current_user(message)
          message.sender == current_user ? message.recipient : message.sender
        end
        
        def reply?
          not params[:message][:parent_id] == ""
        end
        
        def preview?
          params["commit"] == "Preview"
        end
            
end

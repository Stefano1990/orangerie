class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :trusted
  before_filter :authorize_create, :except => [:index, :destroy]
  before_filter :authorize_destroy, :except => [:index, :create]
  
  def index
    @commentable = find_commentable
    @comments = @commentable.comments
  end
  
  def create
    @comment = @post.comments.build(params[:comment])
    @comment.user_id = current_user.id
    
    if @comment.save
      flash[:success] = "Comment has been created."
      redirect_to user_path(@post.owner)
    else
      flash[:error] = "Comment was not created."
      redirect_to user_path(@post.owner)
    end
  end
  
  private
      def authorize_create
        @post = Post.find(params[:post_id])
        post_owner = @post.user
        wall_owner = @post.owner
        unless is_friend?(wall_owner) or own_wall?(wall_owner)
          flash[:error] = "You have to be a friend to comment their wall."
          redirect_to user_path(wall_owner)
        end
      end
      
      def authorize_destroy
        @post = Post.find(params[:id])
        redirect_to user_path(@post.owner) unless own_wall?(@post.owner)
      end
      
      def is_friend?(post_owner)
        Connection.accepted?(current_user, post_owner)
      end
      
      def own_wall?(wall_owner)
        current_user == wall_owner
      end
      
      def trusted
        redirect_to trusted_user_path(current_user) unless current_user.trusted
      end
end

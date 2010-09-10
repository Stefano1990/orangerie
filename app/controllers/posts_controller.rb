# NOTE: We use "posts" for both forum topic posts and blog posts,
# There is some trickery to handle the two in a unified manner.
class PostsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :trusted
  before_filter :authorize_create, :except => [:index, :destroy]
  before_filter :authorize_destroy, :except => [:index, :create]

  
  
  
  
  def create
    @post = current_user.posts.build(params[:post])
    
    if @post.save
      flash[:success] = "Wall post created."
      redirect_to user_path(@post.owner)
    else
      flash[:error] = "Your wall post can not be blank."
      redirect_to user_path(@post.owner)
    end
  end
  
  def destroy
    @post.destroy
    
    flash[:success] = "Post destroyed"
    respond_to do |format|
      format.html { redirect_to user_path(@post.wall_id) }
    end
  end
  
  private
  
      ## Before filters
      # Verify the person is authorized to create a post.
      def authorize_create
        wall_owner = User.find(params[:post][:wall_id])
        unless is_friend?(wall_owner) or own_wall?(wall_owner)
          redirect_to user_path(wall_owner)
        end
      end
      
      def authorize_destroy
        @post = Post.find(params[:id])
        redirect_to user_path(@post.owner) unless own_wall?(@post.owner)
      end
      
      def is_friend?(wall_owner)
        Connection.accepted?(current_user, wall_owner)
      end
      
      def own_wall?(wall_owner)
        current_user == wall_owner
      end
      
      def trusted
        redirect_to trusted_user_path(current_user) unless current_user.trusted
      end

end

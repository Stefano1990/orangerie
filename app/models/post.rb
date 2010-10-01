class Post < ActiveRecord::Base
  extend ActivityLogger
  belongs_to :user
  belongs_to :owner, :class_name => "User", :foreign_key => "wall_id"
  
  has_many    :comments, :as => :commentable
  
  # association for the livestreams and feeds
  has_many :activities, :foreign_key => "item_id", :dependent => :destroy,
                          :conditions => "item_type = 'Post'"
  
  validates_presence_of :body, :message => "can't be blank"
  validates_length_of :body, :within => 2..140, :message => "between 3-140 letters"
  
  after_create {|post| Post.log_activity(post)}
  
  private
    class << self
        def log_activity(post)
          activity = Activity.create!(:item => post, :user => post.user)
          add_activities(:activity => activity, :user => post.user, :include_user => post.user)
        end
    end
end

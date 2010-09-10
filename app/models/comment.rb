class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  
  attr_accessible :body
  
  validates_presence_of [:user_id, :commentable_id, :commentable_type, :body ], :message => "can't be blank"
end

class Activity < ActiveRecord::Base  
  belongs_to :user
  belongs_to :item, :polymorphic => true
  has_many :livestreams, :dependent => :destroy
  
  
end

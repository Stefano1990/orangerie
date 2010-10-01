class Activity < ActiveRecord::Base  
  belongs_to :user
  belongs_to :item, :polymorphic => true
  has_many :livestreams, :dependent => :destroy
  
  validates_presence_of [:item_type, :item_id], :on => :create, :message => "can't be blank"
end

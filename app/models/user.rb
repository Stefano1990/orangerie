class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable, :timeoutable and :oauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  
  #validates_presence_of [:email, :password, :password_confirmation]
  validates_length_of :name, :within => 3..30
  validates_presence_of :name
  
  NOT_DELETED = [%(deleted = ?), false]
  REQUESTED_AND_ACTIVE =  [%(status = ?), Connection::REQUESTED]
  ACCEPTED = [%(status = ? AND trusted = ?), Connection::ACCEPTED, true]
  FEED_SIZE = 10
  before_create  {|user| user.build_infos(self)}
  
  #named_scope :unapproved_requests, where({:user_id => self, :approved => false})

  has_many :connections
  has_many :posts, :dependent => :destroy
  has_many :wall_posts, :class_name => "Post", :foreign_key => "wall_id", :order => 'created_at DESC', :include => :user
  
  has_many :contacts, :through => :connections, :order => 'users.created_at DESC', :conditions => ACCEPTED 
  has_many :requested_contacts, :through => :connections,
             :source => :contact,
             :conditions => REQUESTED_AND_ACTIVE
             
  has_one :infos
  
  has_many :livestreams
  has_many :activities, :through => :livestreams, :order => 'activities.created_at DESC',
                                              :limit => FEED_SIZE, :include => :user
  
  attr_reader :per_page
    @@per_page = 10
    
  
  accepts_nested_attributes_for :infos
  
  def common_contacts_with(friend)
    contacts & friend.contacts
  end
  
  def trusted?
    trusted
  end
end

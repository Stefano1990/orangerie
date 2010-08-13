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
  
  REQUESTED_AND_ACTIVE =  [%(status = ?), Connection::REQUESTED]
  before_create  {|user| user.build_infos(self)}
  
  #named_scope :unapproved_requests, where({:user_id => self, :approved => false})

  has_many :connections
  
  has_many :contacts, :through => :connections, :order => 'users.created_at DESC'
  has_many :requested_contacts, :through => :connections,
             :source => :contact,
             :conditions => REQUESTED_AND_ACTIVE
  has_one :infos
end

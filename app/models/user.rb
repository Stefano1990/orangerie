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
  
  has_many    :profile
  before_create  {|user| user.profile.build(self)}
  
end

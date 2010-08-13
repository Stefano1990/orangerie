# == Schema Information
#
#
# Table name: connections
#
#  id          :integer(4)      not null, primary key
#  user_id   :integer(4)      
#  contact_id  :integer(4)      
#  status      :integer(4)      
#  accepted_at :datetime        
#  created_at  :datetime        
#  updated_at  :datetime        
#

class Connection < ActiveRecord::Base
  #extend ActivityLogger
  #extend PreferencesHelper
  
  belongs_to :user
  belongs_to :contact, :class_name => "User", :foreign_key => "contact_id"
  #has_many :activities, :foreign_key => "item_id", :dependent => :destroy,
  #                      :conditions => "item_type = 'Connection'"
  validates_presence_of :user_id, :contact_id
  
  # Status codes.
  ACCEPTED  = 0
  REQUESTED = 1
  PENDING   = 2
  
  # Accept a connection request (instance method).
  # Each connection is really two rows, so delegate this method
  # to Connection.accept to wrap the whole thing in a transaction.
  def accept
    Connection.accept(user_id, contact_id)
  end
  
  def breakup
    Connection.breakup(user_id, contact_id)
  end
  
  class << self
  
    # Return true if the users are (possibly pending) connections.
    def exists?(user, contact)
      not conn(user, contact).nil?
    end
    
    alias exist? exists?
  
    # Make a pending connection request.
    def request(user, contact, send_mail = nil)
      #if send_mail.nil?
      #  send_mail = !global_prefs.nil? && global_prefs.email_notifications? && contact.connection_notifications?
      #end
      if user == contact or Connection.exists?(user, contact)
        nil
      else
        transaction do
          create(:user => user, :contact => contact, :status => PENDING)
          create(:user => contact, :contact => user, :status => REQUESTED)
        end
        #if send_mail
        #  # The order here is important: the mail is sent *to* the contact,
          # so the connection should be from the contact's point of view.
        #  connection = conn(contact, user)
        #  PersonMailer.deliver_connection_request(connection)
        #end
        true
      end
    end
  
    # Accept a connection request.
    def accept(user, contact)
      transaction do
        accepted_at = Time.now
        accept_one_side(user, contact, accepted_at)
        accept_one_side(contact, user, accepted_at)
      end
      # Exclude the first admin to prevent everyone's feed from
      # filling up with new registrants.
      #unless [user, contact].include?(Person.find_first_admin)
      #  log_activity(conn(user, contact))
      #end
    end
    
    def connect(user, contact, send_mail = nil)
      transaction do
        request(user, contact, send_mail)
        accept(user, contact)
      end
      conn(user, contact)
    end
  
    # Delete a connection or cancel a pending request.
    def breakup(user, contact)
      transaction do
        destroy(conn(user, contact))
        destroy(conn(contact, user))
      end
    end
  
    # Return a connection based on the user and contact.
    def conn(user, contact)
      find_by_user_id_and_contact_id(user, contact)
    end
    
    def accepted?(user, contact)
      conn(user, contact).status == ACCEPTED
    end
    
    def connected?(user, contact)
      exist?(user, contact) and accepted?(user, contact)
    end
    
    def pending?(user, contact)
      exist?(user, contact) and conn(contact,user).status == PENDING
    end
  end
  
  private
  
  class << self
    # Update the db with one side of an accepted connection request.
    def accept_one_side(user, contact, accepted_at)
      conn = conn(user, contact)
      conn.update_attributes!(:status => ACCEPTED,
                              :accepted_at => accepted_at)
    end
  
    #def log_activity(conn)
    ##  activity = Activity.create!(:item => conn, :user => conn.user)
    #  add_activities(:activity => activity, :user => conn.user)
    #  add_activities(:activity => activity, :user => conn.contact)
    #end
  end
end
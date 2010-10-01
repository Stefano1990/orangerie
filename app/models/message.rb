class Message < Communication
  
  attr_accessor :reply, :parent, :send_mail
  
  belongs_to :sender, :class_name => "User", :foreign_key => "sender_id"
  belongs_to :recipient, :class_name => "User", :foreign_key => "recipient_id"
  belongs_to :conversation
  
  MAX_CONTENT_LENGTH = 5000
  
  validates_presence_of :subject, :content
  validates_length_of :subject, :maximum => 250
  validates_length_of :content, :maximum => MAX_CONTENT_LENGTH

  before_create :assign_conversation
  after_create  :save_recipient, :set_replied_to, :send_receipt_reminder
               
  def parent
    return @parent unless @parent.nil?
    return Message.find(parent_id) unless parent_id.nil?
  end
  
  def parent=(message)
    self.parent_id = message.id
    @parent = message
  end
  
  # Put the message in the trash for the given user
  def trash(user, time=Time.now)
    case user
    when sender
      self.sender_deleted_at = time
    when recipient
      self.recipient_deleted_at = time
    else
      # Given the controller before filters, this should never happen...
      raise ArgumentError, "Unauthorized user"
    end
    save!
  end
  
  # Return the sender/recipient that *isn't* the given user
  def other_user(user)
    user == sender ? recipient : sender
  end
  
  # Return true if the message has been trashed
  def trashed?(user)
    case user
    when sender
      !sender_deleted_at.nil? and sender_deleted_at > User::TRASH_TIME_AGO
    when recipient
      !recipient_deleted_at.nil? and recipient_deleted_at > User::TRASH_TIME_AGO
    end
  end
  
  # Move the message back to the inbox folder
  def untrash(user)
    return false unless trashed?(user)
    trash(user, nil)
  end
  
  # Return true if the message is a reply to a previous message
  def reply?
    (!parent.nil? or !parent_id.nil?) and valid_reply?
  end
  
  # Return true if the sender/recipient pair is valid for a given parent.
  def valid_reply?
    # People can send multiple replies to the same message, in which case
    # the recipient is the same as the parent recipient.
    # For most replies, the message recipient should be the parent sender.
    # We use Set to handle both cases uniformly.
    Set.new([sender, recipient]) == Set.new([parent.sender, parent.recipient])
  end
  
  # Return true if the message has been replied to.
  def replied_to?
    !replied_at.nil?
  end
  
  # Return true if a message has been read
  def read?
    !recipient_read_at.nil?
  end
  
  # Return true if a message has not been read
  def new?(user)
    not read? and user != sender
  end
  
  # Mark a message as read
  def mark_as_read(time=Time.now)
    unless read?
      self.recipient_read_at = time
      save!
    end
  end
  
  private
      # Assign the conversation id.
      # This is the parent message's conversation unless there is no parent,
      # in which case we create a new conversation.
      def assign_conversation
        self.conversation = parent.nil? ? Conversation.create :
                                          parent.conversation
      end

      # Mark the parent message as replied to if the current message is a reply.
      def set_replied_to
        if reply?
          parent.replied_at = Time.now
          parent.save!
        end
      end

      def update_recipient_last_contacted_at
        self.recipient.last_contacted_at = updated_at
      end

      def save_recipient
        self.recipient.save!
      end

      def send_receipt_reminder
        return if sender == recipient
        #@send_mail ||= !Message.global_prefs.nil? && Message.global_prefs.email_notifications? &&
        #               recipient.message_notifications?
        #PersonMailer.deliver_message_notification(self) if @send_mail
      end
end

require 'spec_helper'

describe Message do
  before(:each) do
    @sender     = Factory(:user)
    @recipient  = Factory(:user, :email => Factory.next(:email), :trusted => true )
    @message    = new_message
  end
  
  it "should be valid" do
    @message.should be_valid
  end
  
  it "should have the right sender" do
    @message.sender.should == @sender
  end
  
  it "should have the right recipient" do
    @message.recipient.should == @recipient
  end
  
  it "should require a subject" do
    new_message(:subject => "").should_not be_valid
  end
  
  it "should require content" do
    new_message(:content => "").should_not be_valid
  end
  
  it "should not be too long" do
    too_long_content = "a" * (Message::MAX_CONTENT_LENGTH + 1)
    new_message(:content => too_long_content).should_not be_valid
  end
  
  it "should be able to trash message as a sender" do
    @message.trash(@message.sender)
    @message.should be_trashed(@message.sender)
    @message.should_not be_trashed(@message.recipient)
  end
  
  it "should be able to trash a message as recipient" do
    @message.trash(@message.recipient)
    @message.should be_trashed(@message.recipient)
    @message.should_not be_trashed(@message.sender)
  end
  
  it "should description not be able to trash as another user" do
    bob = Factory(:user, :email => Factory.next(:email), :trusted => true)
    bob.should_not == @message.sender
    bob.should_not == @message.recipient
    lambda { @message.trash(bob)}.should raise_error(ArgumentError)
  end
  
  it "should untrash a message" do
    @message.trash(@message.sender)
    @message.should be_trashed(@message.sender)
    @message.untrash(@message.sender)
    @message.should_not be_trashed(@message.sender)
    
  end
  
  it "should handle replies" do
    @message.save!
    @reply = create_message( :sender => @message.recipient, 
                             :recipient => @message.sender, 
                             :parent => @message )
    @reply.should be_reply
    @reply.parent.should be_replied_to
  end
  
  it "should not allow anyone but the recipient to reply" do
    bob = Factory(:user, :email => Factory.next(:email), :trusted => true)
    @message.save
    @next_message = create_message(  :sender => bob, 
                                     :recipient => @message.sender, 
                                     :parent => @message )
    @next_message.should_not be_reply
    @next_message.parent.should_not be_replied_to
  end
  
  it "should mark the message as read" do
    @message.mark_as_read
    @message.should be_read
  end
  
  it "should belong to a conversation" do
    @message.should respond_to(:conversation)
  end
  
  it "should assign the conversation id properly" do
    @message.save!
    @message.conversation.should_not be_nil
    @next_message = create_message( :sender => @message.recipient,
                                    :recipient => @message.sender, 
                                    :parent => @message )
    @next_message.conversation.should_not be_nil
    @next_message.conversation == @message.conversation
  end
  
  private
      
      def new_message(options = { :sender => @sender, :recipient => @recipient })
        Message.unsafe_build({ :subject => "The subject", 
                               :content => "Lorem impsum foobar", }.merge(options))
      end
      
      def create_message(options = { :sender => @sender, :recipient => @recipient })
        Message.unsafe_create({ :subject => "The subject", 
                                :content => "Lorem ipsum foobar", }.merge(options))
      end
end

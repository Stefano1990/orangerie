module ConnectionsHelper
  def connection_button(user1, user2)
		if user1 == user2 or Connection.pending?(user1, user2)
      return
    end
    
    if Connection.exists?(user1, user2)
      raw %(#{button_to "Delete friend", connection_path(Connection.conn(user2,user1)), 
  			                  :method => :delete, :title => I18n.t('users.show.delete_friend'),
  			             	    :confirm => "Are you sure you want to delete #{user1.name} from your friends list?", 
  							          :remote => true})
		end
		
    unless Connection.exists?(user1, user2)
			raw %(#{button_to I18n.t('users.show.become_friends'), user_connections_path(user1), :method => :post, :class => "submit-link"})
		end
    
    
  end
end

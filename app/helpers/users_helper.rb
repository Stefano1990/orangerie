module UsersHelper
    def current_user?(user)
      current_user == user
    end
    
    def title
      # this should never happen.
      params[:action] != "unknown_action"
      
      case params[:controller]
        
      when "users"
        case params[:action]
      
        when "livestream"
          %(Livestream)
          
        when "show"
          %(Wall)
          
        when "infos"
          %(Infos)
          
        when "friends"
          %(Friends)
          
        when "photos"
          %(Fotos)
        end
        
      when "messages"
        case params[:action]
          
        when "index"
          %(Messages)
        when "show"
          %(Show Message)
        when "reply"
          %(Reply To Message)
        when "new"
          %(New Message)
        when "sent"
          %(Sent Messages)
        when "trash"
          %(Trashed Messages)
        end
      end
    end
    
    def user_image_link(user)
      # fetch the right thumb for the user
      raw %(<img src="/images/rails.png" width="25px" height="25px" class="small-profile-pic"> 
          #{link_to user.name, user})
    end
    
    def send_message_link(user, image=false)
      # makes a link to send a message to a user
      # if image = true, a little message icon is displayed
      if image == true
        raw %(<img src="/images/rails.png" width="25px" height="25px" class="small-profile-pic">
              #{link_to user.name, new_user_message_path(user)})
      else
        raw %(#{link_to user.name, new_user_message_path(user)})
      end
    end
    
    def smoking(state)
      if state == true
        "Ja"
      else
        "Nein"
      end
    end
    
    def sexual_pronoun(sex)
      case sex
        
      when "Mann"
        raw %(ich)
      when "Frau"
        raw %(ich)
      when "Paar"
        raw %(wir)
      end
    end
    
    def is_friend?(user)
      Connection.connected?(user, current_user)
    end
end
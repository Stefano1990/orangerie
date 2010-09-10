module UsersHelper
    def current_user?(user)
      current_user == user
    end
    
    def smoking(state)
      if state == true
        "Ja"
      else
        "Nein"
      end
    end
    
    def own_profile?
      displayed_user = User.find(params[:id])
      displayed_user == current_user
    end
    
    def is_friend?(user)
      Connection.connected?(user, current_user)
    end
end
module ActivityLogger

  # Add an activity to the livestreams of a user's contacts.
  # Usually, we only add to the livestreams of the contacts, not the user himself.
  # For example, if a user makes a forum post, the activity shows up in
  # his contacts' livestreams but not his.
  # The :include_user option is to handle the case when add_activities
  # should include the user as well.  This happens when
  # someone comments on a user's blog post or wall.  In that case, when
  # adding activities to the contacts of the wall's or post's owner,
  # we should include the owner as well, so that he sees in his livestream
  # that a comment has been made.
  def add_activities(options = {})
    user = options[:user]
    include_user = options[:include_user]
    activity = options[:activity] ||
               Activity.create!(:item => options[:item], :user => user)
    
    users_ids = users_to_add(user, activity, include_user)
    do_livestream_insert(users_ids, activity.id) unless users_ids.empty?
  end
  
  private
  
    # Return the ids of the users whose livestreams need to be updated.
    # The key step is the subtraction of users who already have the activity.
    def users_to_add(user, activity, include_user)
      all = user.contacts.map(&:id)
      all.push(user.id) if include_user
      all - already_have_activity(all, activity)
    end
  
    # Return the ids of users who already have the given livestream activity.
    # The results of the query are livestream objects with only a user_id
    # attribute (due to the "DISTINCT user_id" clause), which we extract
    # using map(&:user_id).
    def already_have_activity(users, activity)
      Livestream.find(:all, :select => "DISTINCT user_id",
                      :conditions => ["user_id IN (?) AND activity_id = ?",
                                      users, activity]).map(&:user_id)    
    end
  
    # Return the SQL values string needed for the SQL VALUES clause.
    # Arguments: an array of ids and a common value to be inserted for each.
    # E.g., values([1, 3, 4], 17) returns "(1, 17), (3, 17), (4, 17)"
    def values(ids, common_value)
      common_values = [common_value] * ids.length
      convert_to_sql(ids.zip(common_values))
    end

    # Convert an array of values into an SQL string.
    # For example, [[1, 2], [3, 4]] becomes "(1,2), (3, 4)".
    # This does no escaping since it currently only needs to work with ints.
    def convert_to_sql(array_of_values)
      array_of_values.inspect[1...-1].gsub('[', '(').gsub(']', ')')
    end
  
    def do_livestream_insert(users_ids, activity_id)
      sql = %(INSERT INTO livestreams (user_id, activity_id) 
              VALUES #{values(users_ids, activity_id)})
      ActiveRecord::Base.connection.execute(sql)
    end
end
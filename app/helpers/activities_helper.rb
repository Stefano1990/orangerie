module ActivitiesHelper

  # Given an activity, return a message for the livestream for the activity's class.
  def livestream_message(activity, own_wall = false)
    user = activity.user
    case activity_type(activity)
   
    when "Connection"
        if own_wall
          raw %(<div id="user-show-post">You are now friends with #{connection_link(activity.item, false)}</div>) 
        else
          raw %(<div id="user-show-post">#{connection_link(activity.item, true)} and
            #{connection_link(activity.item, false)} are now friends.</div>)
        end
    
    when "Post"
      item = activity.item
      relationship = relationship(item)
      case relationship
        
        when 1
          raw %(<div id="user-show-post">You wrote on your own wall: <br/>
              #{truncate(item.body, :length => 20)}</div>)
        when 2
          raw %(<div id="user-show-post">#{link_to item.user.name, item.user} wrote on your wall</div>)
        when 3
          raw %(<div id="user-show-post">#{link_to item.user.name, item.user} wrote on his wall</div>)
        when 4
          raw %(<div id="user-show-post">You wrote on #{link_to item.user.name, item.user}'s wall</div>)
        when 5
          raw %(<div id="user-show-post">#{link_to item.user.name, item.user} wrote on 
              #{link_to item.owner.name, item.owner}'s wall</div>)
      end
      
    when "Comment"
        if own_wall
          raw %(<div id="user-show-post">You are commented on your own wall #{connection_link(activity.item)}</div>) 
        else
          raw %(<div id="user-show-post">#{link_to activity.item.contact.name, activity.item.contact} and
            #{link_to activity.item.user.name, activity.item.user} are now friends.</div>)
        end
    end
    
  end
  
  def someones(person, commenter, link = true)
    link ? "#{person_link_with_image(person)}'s" : "#{h person.name}'s"
  end
  
  def connection_link(item, contact = false)
    contact ? link_to(item.contact.name, item.contact) : link_to(item.user.name, item.user)
  end
  
  def blog_link(text, blog)
    link_to(text, blog_path(blog))
  end
  
  def post_link(item, contact = false)
    if item.wall_id == item.user_id 
      # person comments on his/her own wall
    end
    if item.wall_id == current_user.id
      # post on own wall but not known if the owner of the profile wrote the post
      if item.user_id == current_user.id
        # post is on the own wall and the owner of the profile wrote the post
      else
        # post is on own wall but the owner of the post is different
      end
    end
    
    contact ? link_to(item.owner.name, item.owner) : link_to(item.user.name, item.user)
  end
  
  def topic_link(text, topic = nil)
    if topic.nil?
      topic = text
      text = topic.name
    end
    link_to(text, forum_topic_path(topic.forum, topic))
  end
  
  def gallery_link(text, gallery = nil)
    if gallery.nil?
      gallery = text
      text = gallery.title
    end
    link_to(h(text), gallery_path(gallery))
  end
  
  def to_gallery_link(text = nil, gallery = nil)
    if text.nil?
      ''
    else
      'to the ' + gallery_link(text, gallery) + ' gallery'
    end
  end
  
  def photo_link(text, photo= nil)
    if photo.nil?
      photo = text
      text = "photo"
    end
    link_to(h(text), photo_path(photo))
  end

  def event_link(text, event)
    link_to(text, event_path(event))
  end

  def relationship(item) 
    user = item.user
    contact = item.owner if item.respond_to? :owner
    contact = item.contact if item.respond_to? :contact
    
    
    
    if current_user != contact or current_user != user
      return 5
    else
      if current_user == contact
        if current_user == user
          return 1
        else
          return 2
        end
      else
        if contact == user
          return 3
        else
          return 4
        end
      end
    end
    
  end
  # Return a link to the wall.
  def wall(activity)
    commenter = activity.person
    person = activity.item.commentable
    link_to("#{someones(person, commenter, false)} wall",
            person_path(person, :anchor => "tWall"))
  end
  
  # Only show member photo for certain types of activity
  def posterPhoto(activity)
    shouldShow = case activity_type(activity)
    when "Photo"
      true
    when "Connection"
      true
    else
      false
    end
    if shouldShow
      image_link(activity.person, :image => :thumbnail)
    end
  end
  
  private
  
    # Return the type of activity.
    # We switch on the class.to_s because the class itself is quite long
    # (due to ActiveRecord).
    def activity_type(activity)
      activity.item.class.to_s      
    end
end
module ActivitiesHelper

  # Given an activity, return a message for the livestream for the activity's class.
  def livestream_message(activity, recent = false)
    user = activity.user
    case activity_type(activity)
   
    when "Connection"
        if recent
          raw %(connected with #{link_to activity.item.contact.name, activity.item.contact} ) 
        else
          raw %(#{link_to activity.item.contact.name, activity.item.contact} and
            #{link_to activity.item.user.name, activity.item.user} have connected)
        end
    
    when "Post"
      raw %(#{activity.item.contact.name} wrote on his wall: 
      #{truncate(activity.item.body, :length => 20)} ) 
    end
    
  end
  
  def someones(person, commenter, link = true)
    link ? "#{person_link_with_image(person)}'s" : "#{h person.name}'s"
  end
  
  def blog_link(text, blog)
    link_to(text, blog_path(blog))
  end
  
  def post_link(text, blog, post = nil)
    if post.nil?
      post = blog
      blog = text
      text = post.title
    end
    link_to(text, blog_post_path(blog, post))
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
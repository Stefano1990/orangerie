module ApplicationHelper
  
  def title
    base_title = "Orangerie Le Club"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title} | Swingerclub Fun Sauna Restaurant"
    end
  end
  
end

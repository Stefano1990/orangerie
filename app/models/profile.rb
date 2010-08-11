class Profile < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :age, :weight, :height, :hair_color, :eye_color, :appearance,
                  :bi_tendency, :sex_tend, :region, :mobility, :smoking, :about_us, 
                  :for_text, :like, :dislike, :looking_for, :to_do
                  
  validates_numericality_of [:age, :weight, :height], :message => "Bitte eine Zahl eingeben", :on => "update"
  
end

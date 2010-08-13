class Infos < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :sex, :region, :mobility, :about_us, 
                  :for_text, :like, :dislike, :looking_for, :to_do,
                  :age_m, :weight_m, :height_m, :hair_color_m, :eye_color_m, :appearance_m,
                  :bi_tendency_m, :sex_tend_m, :smoking_m,
                  :age_f, :weight_f, :height_f, :hair_color_f, :eye_color_f, :appearance_f,
                  :bi_tendency_f, :sex_tend_f, :smoking_f
  
  validates_presence_of     :age_m, :weight_m, :height_m, :if => :is_male?, :on => :update
  validates_numericality_of :age_m, :weight_m, :height_m, :if => :is_male?, :on => :update
  
  validates_presence_of     :age_f, :weight_f, :height_f, :if => :is_female?, :on => :update
  validates_numericality_of :age_f, :weight_f, :height_f, :if => :is_female?, :on => :update
  
  validates_presence_of     :age_m, :weight_m, :height_m,
                            :age_f, :weight_f, :height_f, :if => :is_couple?, :on => :update
  validates_numericality_of :age_m, :weight_m, :height_m,
                            :age_f, :weight_f, :height_f, :if => :is_couple?, :on => :update
  
  def is_male?
    sex == "Mann"
  end
  
  def is_female?
    sex == "Frau"
  end
  
  def is_couple?
    sex == "Paar"
  end
end
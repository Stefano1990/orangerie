class CreateInfos < ActiveRecord::Migration
  def self.up
    create_table(:infos) do |t|
      t.integer     :user_id
      t.string      :sex
  
      # all the values for the guy
      t.integer  :age_m
      t.integer  :weight_m
      t.integer  :height_m               
      t.string :hair_color_m
      t.string :eye_color_m
      t.string :appearance_m  
      t.string :bi_tendency_m
      t.string :sex_tend_m
      t.boolean :smoking_m
  
      # all the values for the woman
      t.integer  :age_f
      t.integer  :weight_f
      t.integer  :height_f               
      t.string :hair_color_f
      t.string :eye_color_f
      t.string :appearance_f  
      t.string :bi_tendency_f
      t.string :sex_tend_f
      t.boolean :smoking_f
  
      # the values that are shared      
      t.string :region
      t.string :mobility                                        
      t.text :about_us
      t.text :for_text
      t.text :like
      t.text :dislike
      t.text :looking_for
      t.text :to_do
  
      t.timestamps
    end
  end

  def self.down
  end
end

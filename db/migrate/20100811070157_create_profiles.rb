class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      
      t.integer  :user_id
      t.integer  :age      
      t.integer  :weight
      t.integer  :height  
                                        
      t.string :hair_color
      t.string :eye_color
      t.string :appearance  
      t.string :bi_tendency
      t.string :sex_tend
      t.string :region     
      t.string :mobility
                                        
      t.boolean :smoking
                                        
      t.text :about_us
      t.text :for_text
      t.text :like
      t.text :dislike
      t.text :looking_for
      t.text :to_do  
      
      t.timestamps
    end
    
    add_index :profiles, :user_id
  end

  def self.down
    drop_table :profiles
  end
end

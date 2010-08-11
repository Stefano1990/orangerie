class AddStuffToUserInfos < ActiveRecord::Migration
  def self.up
    add_column :user_infos, :age,         :integer
    add_column :user_infos, :weight,      :integer
    
    add_column :user_infos, :hair_color,  :string
    add_column :user_infos, :eye_color,   :string
    add_column :user_infos, :appearance,  :string
    add_column :user_infos, :bi_tendency, :string
    add_column :user_infos, :sex_tend,    :string
    add_column :user_infos, :region,      :string
    add_column :user_infos, :mobility,    :string
    
    add_column :user_infos, :smoking,     :boolean
    
    add_column :user_infos, :about_us,    :text
    add_column :user_infos, :for_text,    :text
    add_column :user_infos, :like,        :text
    add_column :user_infos, :dislike,     :text
    add_column :user_infos, :looking_for, :text
    add_column :user_infos, :to_do,       :text
  end

  def self.down
    drop_table :user_infos
  end
end

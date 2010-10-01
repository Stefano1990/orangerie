class CreateLivestreams < ActiveRecord::Migration
  def self.up
    create_table :livestreams do |t|
      t.integer     :user_id
      t.integer     :activity_id
      
    end
    add_index :livestreams, :user_id
    add_index :livestreams, :activity_id
  end

  def self.down
    drop_table :livestreams
  end
end

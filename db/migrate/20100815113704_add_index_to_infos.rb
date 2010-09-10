class AddIndexToInfos < ActiveRecord::Migration
  def self.up
    add_index :infos, :user_id
  end

  def self.down
    remove_index :infos, :user_id
  end
end

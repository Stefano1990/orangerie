class AddIndexToPosts < ActiveRecord::Migration
  def self.up
    add_index :posts, :user_id
    add_index :posts, :wall_id
  end

  def self.down
    remove_index :posts, :user_id
    remove_index :posts, :wall_id
  end
end

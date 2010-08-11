class RemoveEmailNameFromUserInfos < ActiveRecord::Migration
  def self.up
    remove_column :user_infos, :email
    remove_column :user_infos, :name
  end

  def self.down
    add_column :users_infos, :email, :string
    add_column :users_infos, :name, :string
  end
end

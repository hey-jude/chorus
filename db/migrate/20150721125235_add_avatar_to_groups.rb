class AddAvatarToGroups < ActiveRecord::Migration
  def self.up
    change_table :groups do |t|
      t.has_attached_file :avatar
    end
  end

  def self.down
    drop_attached_file :users, :avatar
  end
end

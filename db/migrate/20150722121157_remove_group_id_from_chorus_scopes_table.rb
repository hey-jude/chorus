class RemoveGroupIdFromChorusScopesTable < ActiveRecord::Migration
  def up
    remove_column :chorus_scopes , :group_id
  end

  def down
    add_column :chorus_scopes , :group_id , :integer
  end
end

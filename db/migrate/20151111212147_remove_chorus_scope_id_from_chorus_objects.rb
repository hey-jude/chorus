class RemoveChorusScopeIdFromChorusObjects < ActiveRecord::Migration
  def change
    remove_column :chorus_objects, :chorus_scope_id
  end
end

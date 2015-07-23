class CreateGroupsChorusScopesTable < ActiveRecord::Migration
  def change
    create_table :chorus_scopes_groups do |t|
      t.integer :group_id
      t.integer :chorus_scope_id
    end
  end
end

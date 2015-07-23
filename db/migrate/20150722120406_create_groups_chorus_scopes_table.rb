class CreateGroupsChorusScopesTable < ActiveRecord::Migration
  def change
    create_table :groups_chorus_scopes do |t|
      t.integer :group_id
      t.integer :chorus_scope_id
    end
  end
end

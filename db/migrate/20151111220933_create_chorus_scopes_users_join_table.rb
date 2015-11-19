class CreateChorusScopesUsersJoinTable < ActiveRecord::Migration
  def change
    create_table :chorus_scopes_users, id: false do |t|
      t.integer :chorus_scope_id
      t.integer :user_id
    end

    add_index :chorus_scopes_users, :chorus_scope_id
    add_index :chorus_scopes_users, :user_id
 end
end

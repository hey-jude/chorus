class AddChorusObjectScopesJoinTable < ActiveRecord::Migration
  def change
    create_table :chorus_objects_scopes, id: false do |t|
      t.integer :chorus_object_id
      t.integer :chorus_scope_id
    end

    add_index :chorus_objects_scopes, :chorus_object_id
    add_index :chorus_objects_scopes, :chorus_scope_id
  end
end

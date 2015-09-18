class ChangeScopeToChorusScope < ActiveRecord::Migration
  def up
    rename_column :chorus_objects, :scope_id, :chorus_scope_id
  end

  def down
  end
end

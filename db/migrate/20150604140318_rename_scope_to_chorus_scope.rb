class RenameScopeToChorusScope < ActiveRecord::Migration
  def up
    rename_table :scopes, :chorus_scopes
  end

  def down
  end
end

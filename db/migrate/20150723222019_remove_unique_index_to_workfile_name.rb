class RemoveUniqueIndexToWorkfileName < ActiveRecord::Migration

  # We are removing this uniqueness constraint on the SQL level to accomodate "published worklets" that can have the same name as an existing workfile
  # The uniqueness constraint will be enforced on the model level, please see workfile.rb and published_worklet.rb

  def up
    execute "DROP INDEX index_workfiles_on_file_name_and_workspace_id"
  end

  def down
    execute "CREATE UNIQUE INDEX index_workfiles_on_file_name_and_workspace_id ON workfiles (file_name, workspace_id) WHERE deleted_at IS NULL"
  end

end

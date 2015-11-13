class WorkletVariableVersionsRenameRunVersionColumnToEventId < ActiveRecord::Migration
  def up
    rename_column :worklet_variable_versions, :run_version, :event_id
  end

  def down
    rename_column :worklet_variable_versions, :event_id, :run_version
  end
end

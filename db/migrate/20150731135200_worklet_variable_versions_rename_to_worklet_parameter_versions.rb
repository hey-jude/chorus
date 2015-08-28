class WorkletVariableVersionsRenameToWorkletParameterVersions < ActiveRecord::Migration
  def change
    rename_table :worklet_variable_versions, :worklet_parameter_versions
    rename_column :worklet_parameter_versions, :worklet_variable_id, :worklet_parameter_id
  end
end

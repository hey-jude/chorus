class WorkletVariablesRenameToWorkletParameters < ActiveRecord::Migration
  def change
    rename_table :worklet_variables, :worklet_parameters
  end
end

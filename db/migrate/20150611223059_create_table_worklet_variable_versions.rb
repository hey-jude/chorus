class CreateTableWorkletVariableVersions < ActiveRecord::Migration
  def change
    create_table :worklet_variable_versions do |t|
      t.references :worklet_variable
      t.integer :owner_id
      t.text :value
      t.integer :run_version
      t.text :result_id
      t.timestamp :deleted_at

      t.timestamps
    end
  end
end

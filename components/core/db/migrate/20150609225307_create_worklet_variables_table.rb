class CreateWorkletVariablesTable < ActiveRecord::Migration
  def change
    create_table :worklet_variables do |t|
      t.references :workfile
      t.boolean :use_default
      t.text :variable_name
      t.text :label
      t.text :data_type
      t.text :description
      t.boolean :required
      t.text :additional_data
      t.timestamp :deleted_at

      t.timestamps
    end
  end
end

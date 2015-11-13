class CreateTableRunningWorkfiles < ActiveRecord::Migration
  def change
    create_table :running_workfiles do |t|
      t.integer :owner_id
      t.integer :workfile_id
      t.text :killable_id

      t.timestamp :deleted_at

      t.timestamps
    end
  end
end

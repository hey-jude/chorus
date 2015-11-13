class AddStatusColumnToRunningWorkfiles < ActiveRecord::Migration
  def change
    add_column :running_workfiles, :status, :string
  end
end

class AddParentIdToChorusObject < ActiveRecord::Migration
  def change
    add_column :chorus_objects, :parent_id, :integer
  end
end

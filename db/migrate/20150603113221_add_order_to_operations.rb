class AddOrderToOperations < ActiveRecord::Migration
  def change
    add_column :operations, :sequence, :integer
  end
end

class CreateTablesForAuthorizationSimpler < ActiveRecord::Migration
  def up
    add_column :users, :roles, :string, array:true, default: []
  end

  def down
    remove_column :users, :roles
  end
end
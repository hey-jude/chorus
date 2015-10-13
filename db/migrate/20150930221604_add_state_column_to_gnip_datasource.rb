class AddStateColumnToGnipDatasource < ActiveRecord::Migration
  def change
    add_column :gnip_data_sources, :state, :string, :default => ''
  end
end

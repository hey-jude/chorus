class AddMetaDataColumnToHdfsEntry < ActiveRecord::Migration
  def change
    add_column :hdfs_entries, :metadata, :json
  end
end

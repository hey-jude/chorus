class AddHiveMetastoreLocationToHdfsDataSource < ActiveRecord::Migration
  def up
    change_table :hdfs_data_sources do |t|
      t.boolean :is_hdfs_hive
      t.string :hive_metastore_location
    end
  end

  def down
    change_table :hdfs_data_sources do |t|
      t.remove :is_hdfs_hive
      t.remove :hive_metastore_location
    end
  end
end
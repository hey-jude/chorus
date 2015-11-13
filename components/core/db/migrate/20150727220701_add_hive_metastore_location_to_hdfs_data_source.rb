class AddHiveMetastoreLocationToHdfsDataSource < ActiveRecord::Migration
  def up
    change_table :hdfs_data_sources do |t|
      t.boolean :is_hdfs_hive
      t.string :hive_metastore_location
    end

    HdfsDataSource.reset_column_information

    # KT: Migrate these values out of the connection_parameters hash.  Chester has told me that no customers will have them,
    # but let's be neat, and save the effort for our QA team and servers.
    HdfsDataSource.all.each do |ds|

      searchable_hash = Hash[ds.connection_parameters.map { |h| [h["key"], h["value"]] }]

      if searchable_hash.keys.include? 'is_hive'
        array = ds.connection_parameters.select{|hash| hash['key'] == 'is_hive'}
        hash = array.first
        ds.is_hdfs_hive = hash['value']
        ds.connection_parameters -= array
      end

      if searchable_hash.keys.include? 'hive.metastore.uris'
        array = ds.connection_parameters.select{|hash| hash['key'] == 'hive.metastore.uris'}
        hash = array.first
        ds.hive_metastore_location = hash['value']
        ds.connection_parameters -= array
      end

      ds.save if ds.changed?
    end
  end

  def down
    change_table :hdfs_data_sources do |t|
      t.remove :is_hdfs_hive
      t.remove :hive_metastore_location
    end
  end

end
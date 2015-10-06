module Hdfs
  class DataSourceRegistrar
    def self.create!(connection_config, owner)
      data_source = HdfsDataSource.new(connection_config)
      data_source.owner = owner

      if connection_config['state'] == 'incomplete'
        data_source.save!(:validate => false)
      else
        verify_accessibility!(data_source)
        data_source.version = Hdfs::QueryService.version_of(data_source)
        data_source.save!
      end

      Events::HdfsDataSourceCreated.by(owner).add(:hdfs_data_source => data_source)
      data_source
    end

    def self.update!(data_source_id, connection_config, updater)
      data_source = HdfsDataSource.find(data_source_id)
      data_source.attributes = connection_config.except(:version)

      unless (connection_config['state'] == 'incomplete')
        data_source.version = Hdfs::QueryService.version_of(data_source)
        verify_accessibility!(data_source)
      end

      if data_source.name_changed? && data_source.valid?
        Events::HdfsDataSourceChangedName.by(updater).add(
          :hdfs_data_source => data_source,
          :old_name => data_source.name_was,
          :new_name => data_source.name
        )
      end

      if connection_config['state'] == 'incomplete'
        data_source.save!(:validate => false)
      else
        data_source.save!
      end

      data_source
    end


    def self.verify_accessibility!(data_source)
      unless Hdfs::QueryService.accessible?(data_source)
        raise ApiValidationError.new(:connection, :generic, {:message => "Unable to reach server at #{data_source.host}:#{data_source.port}. Check connection parameters."})
      end
    end
  end
end

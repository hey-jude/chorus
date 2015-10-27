class MarkUnsupportedHdfsIncomplete < ActiveRecord::Migration
  def change
    versions = [
        'Cloudera CDH5',
        'Cloudera CDH5.3',
        'Cloudera CDH5.4',
        'Hortonworks HDP 2',
        'Hortonworks HDP 2.2',
        'IBM Big Insights 4.0',
        'MapR4',
        'Pivotal HD 3'
    ]
    unsupported_data_sources = HdfsDataSource.where.not(:hdfs_version => versions)

    unsupported_data_sources.each do |data_source|
      data_source.update_attributes(:state => 'incomplete')
    end
  end
end

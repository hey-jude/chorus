module Api
  class HdfsDataSourcePresenter < ApiPresenter

    def to_hash
      hash = {
        :id => model.id,
        :name => model.name,
        :entity_type => model.entity_type_name,
        :supports_work_flows => model.supports_work_flows,
        :hdfs_version => model.hdfs_version,
        :is_hdfs_hive => model.is_hdfs_hive,
        :hive_metastore_location => model.hive_metastore_location,
        :is_deleted => model.deleted?,
        :state => model.state
      }
      unless succinct?
        hash.merge!({
                      :host => model.host,
                      :port => model.port,
                      :online => model.online?,
                      :description => model.description,
                      :version => model.version,
                      :username => model.username,
                      :group_list => model.group_list,
                      :job_tracker_host => model.job_tracker_host,
                      :job_tracker_port => model.job_tracker_port,
                      :high_availability => model.high_availability?,
                      :connection_parameters => model.connection_parameters_including_hive
                    }.merge(owner_hash).
                      merge(tags_hash))
      end
      hash
    end

    def complete_json?
      !rendering_activities? && !succinct?
    end

    private

    def tags_hash
      rendering_activities? ? {} : {:tags => present(model.tags)}
    end

    def owner_hash
      if rendering_activities?
        {}
      else
        {:owner => present(model.owner)}
      end
    end
  end
end
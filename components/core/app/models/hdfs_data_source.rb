class HdfsDataSource < ActiveRecord::Base
  include TaggableBehavior
  include Notable
  include SoftDelete
  include CommonDataSourceBehavior

  attr_accessible :name, :host, :port, :description, :username, :group_list, :job_tracker_host, :job_tracker_port, :hdfs_version, :high_availability, :connection_parameters, :hive_metastore_location, :is_hdfs_hive, :state

  belongs_to :owner, :class_name => 'User'
  has_many :activities, :as => :entity
  has_many :events, :through => :activities
  has_many :hdfs_entries
  has_many :workfile_execution_locations, -> { where :execution_location_type => 'HdfsDataSource' }, :foreign_key => :execution_location_id, :dependent => :destroy
  validates_presence_of :name, :host
  validates_presence_of :port, :unless => :high_availability?
  validates_inclusion_of :hdfs_version, :in => ChorusConfig.instance.hdfs_versions
  validates_length_of :name, :maximum => 64

  validates_with DataSourceNameValidator

  serialize :connection_parameters, JsonArraySerializer

  after_create :create_root_entry
  after_destroy :enqueue_destroy_children
  after_destroy :create_deleted_event, :if => :current_user

  def self.with_job_tracker
    where('job_tracker_host IS NOT NULL and job_tracker_port IS NOT NULL')
  end

  def self.refresh(id)
    find(id).refresh
  end

  def self.check_status(id)
    data_source = HdfsDataSource.find(id)
    data_source.check_status! unless data_source.disabled?
  rescue => e
    Rails.logger.error "Unable to check status of DataSource: #{data_source.inspect}"
    Rails.logger.error "#{e.message} :  #{e.backtrace}"
  end

  def update_state_and_version
    self.state = Hdfs::QueryService.accessible?(self) ? "online" : "offline"
  end

  def refresh(path = "/")
    return if disabled?
    entries = HdfsEntry.list(path, self)
    entries.each { |entry| refresh(entry.path) if entry.is_directory? }
  rescue Hdfs::DirectoryNotFoundError => e
    return unless path == '/'
    hdfs_entries.each do |hdfs_entry|
      hdfs_entry.mark_stale!
    end
  end

  def create_root_entry
    hdfs_entries.create({:hdfs_data_source => self, :path => "/", :is_directory => true}, {:without_protection => true})
  end

  def data_source
    self
  end

  def supports_work_flows
    !!(job_tracker_host && job_tracker_port)
  end

  def connection_parameters_including_hive
    return unless connection_parameters

    params = connection_parameters.clone

    if is_hdfs_hive
      params << {"key" => "is_hive", "value" => "true"}
      params << {"key" => 'hive.metastore.uris', "value" => hive_metastore_location}

      # KT see: https://alpine.atlassian.net/browse/DEV-12009
      searchable_hash = Hash[params.map { |h| [h["key"], h["value"]] }]
      unless searchable_hash.keys.include? 'hive.metastore.client.connect.retry.delay'
        params << {"key" => 'hive.metastore.client.connect.retry.delay', "value" => '1'}
      end
      unless searchable_hash.keys.include? 'hive.metastore.client.socket.timeout'
        params << {"key" => 'hive.metastore.client.socket.timeout', "value" => '600'}
      end
    end

    params
  end

  def hdfs_pairs
    connection_parameters_including_hive.map { |hsh| com.emc.greenplum.hadoop.plugins.HdfsPair.new(hsh['key'], hsh['value']) } if connection_parameters_including_hive
  end

  def license_type
    %(#{hdfs_version}+#{version})
  end

  def enqueue_check_status!
    QC.enqueue_if_not_queued('HdfsDataSource.check_status', self.id)
  end

  private

  def enqueue_destroy_children
    HdfsDataset.destroy_datasets(id)
    QC.enqueue_if_not_queued('HdfsEntry.destroy_entries', id)
  end

  def create_deleted_event
    Events::DataSourceDeleted.by(current_user).add(:data_source => self)
  end
end

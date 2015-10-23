class JdbcDataSource < DataSource
  include SingleLevelDataSourceBehavior

  alias_attribute :url, :host

  has_many :schemas, :as => :parent, :class_name => 'JdbcSchema'
  has_many :datasets, :through => :schemas
  has_many :workfile_execution_locations, -> { where :execution_location_type => 'DataSource' },
           :foreign_key => :execution_location_id, :dependent => :destroy

  def self.create_for_user(user, data_source_hash)
    data_source = user.jdbc_data_sources.new(data_source_hash, :as => :create)
    data_source.save_if_incomplete!(data_source_hash)
  end

  private

  def connection_class
    JdbcConnection
  end

  def cancel_imports
    #no-op
  end

  def enqueue_destroy_schemas
    QC.enqueue_if_not_queued('JdbcSchema.destroy_schemas', id)
  end
end
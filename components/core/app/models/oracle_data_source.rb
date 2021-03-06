class OracleDataSource < ConcreteDataSource
  include SingleLevelDataSourceBehavior

  has_many :schemas, :as => :parent, :class_name => 'OracleSchema'
  has_many :datasets, :through => :schemas
  has_many :imports_as_source, :through => :datasets, :source => :imports
  has_many :workfile_execution_locations, -> { where :execution_location_type => 'DataSource' }, :foreign_key => :execution_location_id, :dependent => :destroy

  def self.create_for_user(user, params)
    data_source = user.oracle_data_sources.new(params) do |data_source|
      data_source.shared = params[:shared]
    end
    data_source.save_if_incomplete!(params)
  end

  private

  def cancel_imports
    imports_as_source.unfinished.each do |import|
      import.cancel(false, "Source/Destination of this import was deleted")
    end
  end

  def enqueue_destroy_schemas
    QC.enqueue_if_not_queued("OracleSchema.destroy_schemas", id)
  end

  def connection_class
    OracleConnection
  end
end

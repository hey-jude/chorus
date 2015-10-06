class PgDataSource < ConcreteDataSource
  include PostgresLikeDataSourceBehavior
  include DataSourceWithSandbox

  has_many :databases, :foreign_key => 'data_source_id', :class_name => 'PgDatabase'

  def self.create_for_user(user, data_source_hash)
    data_source = user.pg_data_sources.new(data_source_hash, :as => :create)
    data_source.save_if_incomplete!(data_source_hash)
  end

  def data_source_provider
    'PostgreSQL Database'
  end

  def cancel_imports
    #no-op until has imports
  end
end

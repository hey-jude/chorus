DataSourceConnection.class_eval do
  def visualization_sql_generator
    raise 'visualization not supported'
  end
end

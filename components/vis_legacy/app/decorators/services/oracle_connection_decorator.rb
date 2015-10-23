OracleConnection.class_eval do
  def visualization_sql_generator
    Visualization::SqlGenerator.new(:limit_type => :oracle).extend(Visualization::OracleSql)
  end
end

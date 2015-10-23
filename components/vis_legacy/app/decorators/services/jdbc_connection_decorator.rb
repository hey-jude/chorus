JdbcConnection.class_eval do

  def visualization_sql_generator
    sql_gen = Visualization::SqlGenerator.new({}).extend(Visualization::JdbcSql)

    sql_gen.extend(@overrides_module.VisualizationOverrides) if !@overrides_module.nil?
    sql_gen
  end
end

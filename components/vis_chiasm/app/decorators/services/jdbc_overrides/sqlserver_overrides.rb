module JdbcOverrides::SqlServer
  def self.VisualizationOverrides
    return Visualization::SqlServerSql
  end
end
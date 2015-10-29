module JdbcOverrides::Hive2
  def self.VisualizationOverrides
    return Visualization::Hive2Sql
  end
end
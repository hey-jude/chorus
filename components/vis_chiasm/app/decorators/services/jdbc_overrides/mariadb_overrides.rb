module JdbcOverrides::Mariadb
  def self.VisualizationOverrides
    return Visualization::MariadbSql
  end
end
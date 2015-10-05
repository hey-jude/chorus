module JdbcOverrides::Teradata
  def self.VisualizationOverrides
    return Visualization::TeradataSql
  end
end
module Visualization
  module TeradataSql
    def self.extend_object(obj)
      super
      obj.limit_type = :top
      obj.numeric_cast = 'numeric(32)'
    end

    def random_sampling_sql(o)
      dataset, numRows = fetch_opts(o, :dataset, :numRows)
      columns = dataset.column_names.sort.map { |n| "\"#{n}\"" }.join(',')
      sourceTable = dataset.scoped_name
      "SELECT #{columns} FROM #{sourceTable} SAMPLE #{numRows}"
    end

  end
end

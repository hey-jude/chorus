module Visualization
  module MySQL

    def self.extend_object(obj)
      super
      obj.limit_type = :limit
    end

    def random_sampling_sql(o)
      dataset, numRows = fetch_opts(o, :dataset, :numRows)
      columns = dataset.column_names.sort.map { |n| "\"#{n}\"" }.join(',')
      sourceTable = dataset.scoped_name
      "SELECT #{columns} FROM #{sourceTable} ORDER BY RAND() LIMIT #{numRows}"
    end
  end
end

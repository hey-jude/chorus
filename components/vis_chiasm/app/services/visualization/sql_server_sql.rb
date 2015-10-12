module Visualization
  module SqlServerSql
    def self.extend_object(obj)
      super
      obj.limit_type = :top
    end

    def random_sampling_sql(o)
      dataset, numRows = fetch_opts(o, :dataset, :numRows)
      columns = dataset.column_names.sort.map { |n| "\"#{n}\"" }.join(',')
      sourceTable = dataset.scoped_name
      "SELECT TOP #{numRows} #{columns} FROM #{sourceTable} ORDER BY NEWID() "
    end

  end
end

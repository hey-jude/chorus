module Visualization
  module OracleSql
    def random_sampling_sql(o)
      dataset, numRows = fetch_opts(o, :dataset, :numRows)
      columns = dataset.column_names.sort.map { |n| "\"#{n}\"" }.join(',')
      sourceTable = dataset.scoped_name
      "SELECT #{columns} FROM (SELECT #{columns} FROM #{sourceTable} ORDER BY dbms_random.value) WHERE ROWNUM <= #{numRows}"
    end
  end
end

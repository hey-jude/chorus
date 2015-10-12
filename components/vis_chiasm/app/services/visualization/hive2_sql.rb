module Visualization
  module Hive2Sql
    def self.extend_object(obj)
      super
      obj.limit_type = :limit
    end

    def random_sampling_sql(o)
      dataset, numRows = fetch_opts(o, :dataset, :numRows)
      columns = dataset.column_names.sort.join(',') # no quotes for
      sourceTable = dataset.scoped_name
      "SELECT #{columns} FROM (SELECT #{columns}, RAND() as alp_rand_order FROM #{sourceTable}) ORDER BY alp_rand_order LIMIT #{numRows}"
    end
  end
end

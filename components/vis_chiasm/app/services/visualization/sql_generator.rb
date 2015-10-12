module Visualization
  class NotImplemented < ApiValidationError
    def initialize
      super :visualization, :not_implemented
    end
  end

  class SqlGenerator
    attr_accessor :limit_type, :numeric_cast, :date_trunc_method

    def initialize(params={})
      @limit_type = params.fetch(:limit, :limit)
      @numeric_cast = params.fetch(:numeric_cast, 'numeric')
      @date_trunc_method = params.fetch(:date_trunc_method, :trunc)
    end

    # def random_sample_order_by_random_query
    #   -- Random sample basic selection where data is sorted by a random value generated for each row and then we take TOP/LIMIT to restrict the number of results
    #
    #   SELECT ${columns} FROM ${sourceTable} ORDER BY ${randomFunctionNoSeed} LIMIT ${limit}
    # end

    def random_sampling_sql(o)
      dataset, numRows = fetch_opts(o, :dataset, :numRows)
      columns = dataset.column_names.sort.map { |n| "\"#{n}\"" }.join(',')
      sourceTable = dataset.scoped_name
      "SELECT #{columns} FROM #{sourceTable} ORDER BY RANDOM() LIMIT #{numRows}"
    end

    private

    def fetch_opts(opts, *keys)
      keys.map { |key| opts.fetch key }
    end
  end
end

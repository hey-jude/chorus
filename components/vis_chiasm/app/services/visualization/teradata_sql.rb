module Visualization
  module TeradataSql
    def self.extend_object(obj)
      super
      obj.limit_type = :top
      obj.numeric_cast = 'numeric(32)'
    end

    # def random_sample
    #   -- Random sample basic selection where a random value is generated for each row and then compared against another random value.
    #   --
    #   -- Single line comments like these will be removed at runtime.
    #   -- Multi line comments using /* */ will not be removed.
    #   --
    #   -- ${columns}: Will be a * (if sensible) or a comma-separated list of columns inserted into string
    #   -- ${sourceTable}: Will use the source table to insert into string below
    #   -- ${randomFunctionNoSeed}: random function that does not need a seed (see randomFunctionNoSeed.sql)
    #   -- ${limit}: Limit the number of rows
    #   -- ${randomValue}: A system generated random value to compare against
    #
    #   SELECT TOP ${limit} ${columns} FROM (SELECT ${columns}, (${randomFunctionNoSeed}) AS rand_order FROM ${sourceTable}) alpfoo WHERE alpfoo.rand_order <= ${randomValue}
    # end

    def random_sampling_sql(o)
      # Michael Thyen TODO -- fill in
      raise NotImplemented
    end

  end
end

module Visualization
  module SqlServerSql
    def self.extend_object(obj)
      super
      obj.limit_type = :top
    end

    def random_sampling_sql(o)
      # Michael Thyen TODO -- fill in
      raise NotImplemented
    end

  end
end

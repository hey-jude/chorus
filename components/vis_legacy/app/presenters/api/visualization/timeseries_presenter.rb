module Api::Visualization
  class TimeseriesPresenter < ApiPresenter
    include GpdbDataTypes

    def to_hash
      {
        :type => model.type,
        :x_axis => model.time,
        :y_axis => model.value,
        :time_interval => model.time_interval,
        :aggregation => model.aggregation,
        :filters => model.filters,
        :rows => model.rows,
        :columns => [{name: "time", type_category: "DATETIME"}, {name: "value", type_category: "REAL_NUMBER"}]
      }
    end
  end
end
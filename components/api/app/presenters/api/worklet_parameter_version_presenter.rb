module Api
  class WorkletParameterVersionPresenter < ApiPresenter
    def to_hash
      worklet_parameter = WorkletParameter.find(model.worklet_parameter_id)
      {
        :result_id => model.result_id,
        :event_id => model.event_id,
        :worklet_parameter_id => model.worklet_parameter_id,
        :owner_id => model.owner_id,
        :value => model.value,
        :name => worklet_parameter.variable_name,
        :label => worklet_parameter.label,
        :data_type => worklet_parameter.data_type
      }
    end
  end
end
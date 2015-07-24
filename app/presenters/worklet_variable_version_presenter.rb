class WorkletVariableVersionPresenter < Presenter
  def to_hash
    worklet_variable = WorkletVariable.find(model.worklet_variable_id)
    {
        :result_id => model.result_id,
        :event_id => model.event_id,
        :worklet_variable_id => model.worklet_variable_id,
        :owner_id => model.owner_id,
        :value => model.value,
        :name => worklet_variable.variable_name,
        :label => worklet_variable.label,
        :data_type => worklet_variable.data_type
    }
  end
end

class WorkletVariablePresenter < Presenter
  def to_hash
    results = {
        :id => model.id,
        :workfile_id => model.workfile_id,
        :description => model.description,
        :variable_name => model.variable_name,
        :label => model.label,
        :data_type => model.data_type,
        :use_default => model.use_default,
        :required => model.required
    }

    results
  end
end

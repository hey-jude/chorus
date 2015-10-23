class WorkletPresenter < AlpineWorkfilePresenter
  def to_hash
    workfile = super

    parameters_array = []
    parameters.each do |parameter|
      parameters_array.push({
        :id => parameter.id,
        :variable_name => parameter.variable_name,
        :label => parameter.label,
        :description => parameter.description,
        :data_type => parameter.data_type,
        :required => parameter.required,
        :use_default => parameter.use_default,
        :workfile_id => parameter.workfile_id,
        :options => parameter.options,
        :validations => parameter.validations
      })
    end

    workfile.merge!({
        :workflow_id => model.workflow_id,
        :run_persona => model.run_persona,
        :output_table => model.output_table,
        :state => model.state,
        :description => model.description,
        :parameters => parameters_array
    })

    running_workfile = RunningWorkfile.where(:workfile_id => model.id, :owner_id => current_user.id)

    workfile.merge!({
        :running => running_workfile.any?
    })

    if running_workfile.any?
      workfile.merge!({
        :killable_id => running_workfile[0].killable_id
      })
    end

    workfile
  end

  def parameters
    model.parameters
  end
end
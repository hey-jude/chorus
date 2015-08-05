class WorkletPresenter < AlpineWorkfilePresenter
  def to_hash
    workfile = super

    variables_array = []
    variables.each do |variable|
      variables_array.push({
        :id => variable.id,
        :variable_name => variable.variable_name,
        :label => variable.label,
        :description => variable.description,
        :data_type => variable.data_type,
        :required => variable.required,
        :use_default => variable.use_default,
        :workfile_id => variable.workfile_id,
        :options => variable.options,
        :validations => variable.validations
      })
    end

    workfile.merge!({
        :workflow_id => model.workflow_id,
        :run_persona => model.run_persona,
        :output_table => model.output_table,
        :state => model.state,
        :description => model.description,
        :variables => variables_array,
        :worklet_image_url => model.worklet_image.url
    })

    workfile.merge!({
        :running => RunningWorkfile.where(:workfile_id => model.id, :owner_id => current_user.id).any?
    })

    workfile
  end

  def variables
    model.variables
  end
end
module Api
  class WorkletParameterPresenter < ApiPresenter
    def to_hash
      results = {
        :id => model.id,
        :workfile_id => model.workfile_id,
        :description => model.description,
        :variable_name => model.variable_name,
        :label => model.label,
        :data_type => model.data_type,
        :use_default => model.use_default,
        :required => model.required,
        :options => model.options,
        :validations => model.validations
      }

      results
    end
  end
end
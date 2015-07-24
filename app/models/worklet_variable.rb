class WorkletVariable < ActiveRecord::Base
  include SoftDelete
  include TaggableBehavior

  belongs_to :worklet

  serialize :additional_data, JsonHashSerializer
  has_additional_data :options, :validations

  attr_accessible :workfile_id,
                  :use_default,
                  :variable_name,
                  :label,
                  :description,
                  :required,
                  :data_type,
                  :is_catalog,
                  :value,
                  :additional_data,
                  :as => [:default, :create]
end
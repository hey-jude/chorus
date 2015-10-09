class WorkletParameterVersion < ActiveRecord::Base
  include SoftDelete
  include TaggableBehavior

  attr_accessible :worklet_parameter_id,
                  :owner_id,
                  :value,
                  :event_id,
                  :result_id,
                  :as => [:default, :create]
end
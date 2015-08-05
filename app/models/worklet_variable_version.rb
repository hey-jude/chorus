class WorkletVariableVersion < ActiveRecord::Base
  include SoftDelete
  include TaggableBehavior

  attr_accessible :worklet_variable_id,
                  :owner_id,
                  :value,
                  :event_id,
                  :result_id,
                  :as => [:default, :create]
end
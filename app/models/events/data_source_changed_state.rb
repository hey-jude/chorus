require 'events/base'

module Events
  class DataSourceChangedState < Base
    has_targets :data_source
    has_additional_data :old_state, :new_state
    has_activities :actor, :data_source, :global
  end
end
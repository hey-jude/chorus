require 'events/base'

module Events
  class JobDeleted < Base
    has_targets :job, :workspace
    has_activities :actor, :job , :workspace
  end
end

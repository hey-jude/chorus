require 'events/base'

module Events
  class JobCreated < Base
    has_targets :job, :workspace
    has_activities :actor, :job , :workspace
  end
end

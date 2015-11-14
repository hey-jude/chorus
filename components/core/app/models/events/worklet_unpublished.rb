module Events
  class WorkletUnpublished < Base
    has_targets :workfile
    has_activities :actor, :workfile, :workspace
  end
end
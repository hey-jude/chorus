module Events
  class WorkletResultShared < Base
    has_targets :workfile
    has_activities :actor, :workfile, :workspace
    has_additional_data :result_note_id

    alias_attribute :is_insight, :insight

    before_validation :set_promoted_info, :if => lambda { insight && insight_changed? }

    def original_worklet_results
      NotesWorkFlowResult.where(:note_id => self.result_note_id.to_i)
    end

    def promote_to_insight
      self.insight = true
      save!
    end

    def demote_from_insight
      self.insight = false
      save!
    end

    def set_insight_published(published)
      self.published = published
      save!
    end

    def set_promoted_info
      self.promoted_by = current_user
      self.promotion_time = Time.current
      true
    end
  end
end
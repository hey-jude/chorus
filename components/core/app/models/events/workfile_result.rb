module Events
  class WorkfileResult < Base
    has_targets :workfile
    has_activities :actor, :workfile, :workspace
    has_additional_data :output_table

    after_create :notify_run_complete, :if => :should_notify?

    def should_notify?
      workfile.type == 'Worklet' || workfile.type == 'PublishedWorklet'
    end

    def notify_run_complete
      Notification.create!(:recipient_id => current_user.id, :event_id => self.id)
      #Mailer.notify_worklet_complete(user, self) if user.subscribed_to_emails?
    end

  end
end
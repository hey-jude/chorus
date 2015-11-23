module Events
  class JobSucceeded < JobFinished
    def self.succeeded
      true
    end

    def header
      "4 The job #{job.name} succeeded in the workspace #{workspace.name}."
    end

    def notify_option
      job.success_notify
    end

    def user_selected_recipients
      job.success_recipients
    end
  end
end
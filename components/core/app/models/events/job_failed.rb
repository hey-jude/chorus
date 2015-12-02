module Events
  class JobFailed < JobFinished
    def self.succeeded
      false
    end

    def header
      "The job #{job.name} failed in the workspace #{workspace.name}"
    end

    def notify_option
      job.failure_notify
    end

    def user_selected_recipients
      job.failure_recipients
    end
  end
end
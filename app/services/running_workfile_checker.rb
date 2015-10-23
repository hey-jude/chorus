class RunningWorkfileChecker
  def self.check_running_workfiles
    running_workfiles = RunningWorkfile.all
    running_workfiles.each do |running_workfile|
      response = Alpine::API.check_work_flow(running_workfile.killable_id, User.find(running_workfile.owner_id))
      if response.body == "false"
        running_workfile.destroy
      end
    end
  end
end

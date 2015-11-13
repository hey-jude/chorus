module Api
  class JobTasksController < ApiController
    wrap_parameters :job_task, :exclude => [:job_id, :workspace_id]

    def create
      Authority.authorize! :update, workspace, current_user, {:or => :can_edit_sub_objects}

      job = Job.find(params[:job_id])
      task = JobTask.assemble!(params[:job_task], job)

      present task, :status => :created
    end

    def destroy

      Authority.authorize! :update, workspace, current_user, {:or => :can_edit_sub_objects}

      JobTask.find(params[:id]).destroy

      head :ok
    end

    def update
      job_task = JobTask.find(params[:id])
      workspace = job_task.job.workspace
      Authority.authorize! :update, workspace, current_user, {:or => :can_edit_sub_objects}

      if params[:job_task][:index] && (job_task.index != params[:job_task][:index])
        job = job_task.job
        job_task_to_swap = job.job_tasks.find_by_index(params[:job_task][:index])
        job_task_to_swap.update_attributes(:index => job_task.index) if job_task_to_swap
      end

      job_task.update_attributes(params[:job_task])

      present job_task
    end

    protected

    def workspace
      @workspace ||= Workspace.find(params[:workspace_id])
    end
  end
end
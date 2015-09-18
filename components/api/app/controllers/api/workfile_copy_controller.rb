module Api
  class WorkfileCopyController < ApiController

    def create
      workfile = Workfile.find(params[:workfile_id])
      Authority.authorize! :show,
                           workfile.workspace,
                           current_user,
                           {:or => [:current_user_is_in_workspace,
                                    :workspace_is_public]}

      workspace = params[:workspace_id].nil? ? workfile.workspace : Workspace.find(params[:workspace_id])
      Authority.authorize! :update, workspace, current_user, {:or => :can_edit_sub_objects}

      copied_workfile = workfile.copy!(current_user, workspace, params[:file_name])

      present copied_workfile.reload, :status => :created
    end
  end
end
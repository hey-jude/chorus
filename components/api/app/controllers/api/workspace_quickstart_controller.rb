module Api
  class WorkspaceQuickstartController < ApiController
    def destroy
      workspace = Workspace.find(params[:workspace_id])
      Authority.authorize! :update, workspace, current_user, {:or => :can_edit_sub_objects}

      workspace.has_added_member = true
      workspace.has_added_sandbox = true
      workspace.has_added_workfile = true
      workspace.has_changed_settings = true
      workspace.save!

      present workspace
    end
  end
end
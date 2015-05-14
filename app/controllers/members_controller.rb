class MembersController < ApplicationController
  def index
    workspace = Workspace.find(params[:workspace_id])
    Authority.authorize! :show, workspace, current_user, { :or => [ :current_user_is_in_workspace,
                                                                    :workspace_is_public ] }

    present paginate WorkspaceAccess.members_for(current_user, workspace)
  end

  def create
    workspace = Workspace.find(params[:workspace_id])
    Authority.authorize! :show, workspace, current_user, { :or => :current_user_is_workspace_owner }

    WorkspaceMembersManager.new(
        workspace,
        { :member => params[:member_ids] },
        current_user
    ).update_membership

    present workspace.reload.members
  end
end

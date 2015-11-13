module Api
  class MembersController < ApiController
    def index
      workspace = Workspace.find(params[:workspace_id])
      Authority.authorize! :show, workspace, current_user, {:or => [:current_user_is_in_workspace,
                                                                    :workspace_is_public]}

      if current_user_is_admin?
        members = workspace.members
      else
        members = workspace.members_accessible_to(current_user)
      end
      members = Workspace.filter_by_scope(current_user, members) if current_user_in_scope?

      present paginate members
    end

    def create
      workspace = Workspace.find(params[:workspace_id])
      Authority.authorize! :show, workspace, current_user, {:or => :current_user_is_object_owner}

      WorkspaceMembersManager.new(
        workspace,
        {"ProjectManager" => params[:member_ids]},
        current_user
      ).update_membership

      present workspace.reload.members
    end
  end
end
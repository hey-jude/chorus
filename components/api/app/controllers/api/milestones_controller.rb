module Api
  class MilestonesController < ApiController
    before_filter :require_milestones
    before_filter :authorize_edit_sub_objects, :only => [:create, :destroy, :update]

    def index
      Authority.authorize! :show, workspace, current_user, {:or => [:current_user_is_in_workspace,
                                                                    :workspace_is_public]}

      milestones = workspace.milestones.order(:target_date)

      present paginate(milestones), :presenter_options => {:list_view => true}
    end

    def create
      milestone = workspace.milestones.create params[:milestone]

      present milestone, :status => :created
    end

    def destroy
      Milestone.find(params[:id]).destroy

      head :ok
    end

    def update
      milestone = workspace.milestones.find(params[:id])
      milestone.update_attributes!(params[:milestone])

      head :ok
    end

    protected

    def workspace
      @workspace ||= Workspace.find(params[:workspace_id])
    end

    def require_milestones
      render_not_licensed if License.instance.limit_milestones?
    end

    def authorize_edit_sub_objects
      Authority.authorize! :update, workspace, current_user, {:or => :can_edit_sub_objects}
    end
  end
end
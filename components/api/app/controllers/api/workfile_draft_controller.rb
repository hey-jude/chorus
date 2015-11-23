module Api
  class WorkfileDraftController < ApiController
    before_filter :find_workfile
    before_filter :authorize_sub_objects, :only => [:create, :update, :destroy]

    def create
      draft = WorkfileDraft.new(params[:workfile_draft])
      draft.workfile_id = params[:workfile_id]
      draft.owner_id = current_user.id
      draft.save!
      present draft, :status => :created
    end

    def show
      Authorization::Authority.authorize! :show,
                           @workfile.workspace,
                           current_user,
                           {:or => [:current_user_is_in_workspace,
                                    :workspace_is_public]}
      draft = WorkfileDraft.find_by_owner_id_and_workfile_id!(current_user.id, params[:workfile_id])
      present draft
    end

    def update
      draft = WorkfileDraft.find_by_owner_id_and_workfile_id!(current_user.id, params[:workfile_id])
      draft.update_attributes!(params[:workfile_draft])
      present draft
    end

    def destroy
      draft = WorkfileDraft.find_by_owner_id_and_workfile_id!(current_user.id, params[:workfile_id])
      draft.destroy
      render :json => {}
    end

    private

    def find_workfile
      @workfile = Workfile.find(params[:workfile_id])
    end

    def authorize_sub_objects
      Authorization::Authority.authorize! :update, @workfile.workspace, current_user, {:or => :can_edit_sub_objects}
    end

  end
end
# KT TODO: does this file work, since the ImagesController is broken?
module Api
  class WorkspaceImagesController < ImagesController

    protected

    def load_entity
      @entity = Workspace.find(params[:workspace_id])
    end

    def authorize_create!
      Authority.authorize! :update, @entity, current_user, {:or => :current_user_is_object_owner}
    end

    def authorize_show!
      Authority.authorize! :show, @entity, current_user, {:or => :current_user_is_in_workspace}
    end
  end
end
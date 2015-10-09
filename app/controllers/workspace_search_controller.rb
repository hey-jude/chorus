class WorkspaceSearchController < ApplicationController
  before_filter :require_full_search

  def show
    workspace = Workspace.find(params[:workspace_id])
    Authority.authorize! :show, workspace, current_user, { :or => :handle_legacy_show }
    present WorkspaceSearch.new(current_user, params)
  end
end

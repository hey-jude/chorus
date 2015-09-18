module Api
  class WorkspaceCsvController < ApiController
    wrap_parameters :csv, :exclude => []

    def create
      workspace = Workspace.find(params[:workspace_id])
      Authority.authorize! :update, workspace, current_user, {:or => :can_edit_sub_objects}
      csv_file = workspace.csv_files.create(params[:csv]) do |file|
        file.user = current_user
      end
      present csv_file
    end
  end
end
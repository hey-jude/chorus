module Api
  class DatasetImportsController < ApiController
    wrap_parameters :dataset_import, :exclude => [:id]

    def index
      workspace = Workspace.find(params[:workspace_id])
      Authority.authorize! :show, workspace, current_user, {:or => [:current_user_is_in_workspace,
                                                                    :workspace_is_public]}
      table = Dataset.find(params[:dataset_id])
      if table.is_a?(ChorusView)
        imports = Import.where(:source_id => table.id, :source_type => 'Dataset').order('created_at DESC')
      else
        imports = Import.where('(source_id = ? AND source_type = ?) OR (to_table = ? AND workspace_id = ?)',
                               table.id, 'Dataset', table.name, workspace.id).order('created_at DESC')
      end
      imports = imports.includes(:destination_dataset)
      imports = Import.filter_by_scope(current_user, imports) if current_user_in_scope?
      present paginate imports
    end

    def update
      ids = [*params[:id]]

      ids.each do |id|
        import = Import.find(id)
        Authority.authorize! :update, import, current_user, {:or => :current_user_is_objects_user}

        unless import.finished_at
          dataset_import_params = params[:dataset_import]
          import.mark_as_canceled!(dataset_import_params[:message])
        end
      end

      respond_to do |format|
        format.json { render :json => {}, :status => 200 }
        format.html { redirect_to ":#{ChorusConfig.instance.server_port}/import_console/imports" }
      end
    end
  end
end
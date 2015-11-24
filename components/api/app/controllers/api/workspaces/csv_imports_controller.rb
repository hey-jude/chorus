# KT TODO: why not inherit from WorkspacesController?
module Api::Workspaces
  class CsvImportsController < ApiController
    wrap_parameters :csv_import, :exclude => []
    before_filter :demo_mode_filter, :only => [:create]

    def create
      csv_file = CsvFile.find params[:csv_id]
      Authorization::Authority.authorize! :create, csv_file, current_user, { :or => :current_user_is_objects_user }

      raise Authorization::AccessDenied.new("Forbidden", :data_source, nil) if csv_file.workspace.sandbox.data_source.disabled?

      file_params = params[:csv_import].slice(:types, :delimiter, :column_names, :has_header, :to_table)
      csv_file.update_attributes!(file_params)

      import_params = params[:csv_import].slice(:to_table, :truncate, :new_table).merge(:csv_file => csv_file, :workspace_id => params[:workspace_id], :user => current_user)
      CsvImport.create!(import_params)
      present [], :status => :created
    end
  end
end
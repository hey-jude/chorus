class GnipDataSourceImportsController < ApplicationController
  wrap_parameters :import, :exclude => []

  def create
    workspace = Workspace.find(params[:import][:workspace_id])

    Authority.authorize! :update, workspace, current_user, { :or => :can_edit_sub_objects }

    GnipImport.create!(:workspace => workspace,
                       :source => data_source,
                       :user => current_user,
                       :to_table => params[:import][:to_table]).enqueue_import

    present [], :status => :ok
  end

  private

  def data_source
    GnipDataSource.find(params[:gnip_data_source_id])
  end
end
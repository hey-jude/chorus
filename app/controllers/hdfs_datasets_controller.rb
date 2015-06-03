class HdfsDatasetsController < ApplicationController
  wrap_parameters :hdfs_dataset, :include => [:name, :file_mask, :data_source_id, :workspace_id]

  def create
    workspace   = Workspace.find params[:hdfs_dataset].delete(:workspace_id)
    Authority.authorize! :update, workspace, current_user, { :or => :can_edit_sub_objects }

    data_source = HdfsDataSource.find params[:hdfs_dataset].delete(:data_source_id)

    dataset     = HdfsDataset.assemble!(params[:hdfs_dataset], data_source, workspace)

    present dataset, :status => :created
  end

  def update
    dataset = Dataset.find(params[:id])
    Authority.authorize! :update, dataset.workspace, current_user, { :or => :can_edit_sub_objects }
    dataset.update_attributes!(params[:hdfs_dataset])

    dataset.make_updated_event

    present dataset
  end

  def destroy
    dataset = Dataset.find(params[:id])
    Authority.authorize! :update, dataset.workspace, current_user, { :or => :can_edit_sub_objects }
    dataset.destroy
    render :json => {}
  end
end
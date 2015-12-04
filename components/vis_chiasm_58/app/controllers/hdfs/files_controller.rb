class Hdfs::FilesController < ApplicationController
  def index
    if params[:id]
      hdfs_entries = HdfsEntry.where(:parent_id => params[:id])
      present hdfs_entries, :presenter_options => {:deep => true}
    else
      hdfs_entry = HdfsEntry.find_by_path_and_hdfs_data_source_id('/', hdfs_data_source.id)
      present hdfs_entry, :presenter_options => {:deep => true}
    end
  rescue Hdfs::PermissionDeniedError
    json = {
        :errors => {:record => :HDFS_KERBEROS_PERMISSION_DENIED}
    }
    render json: json, status: :unprocessable_entity
  end

  def show
    hdfs_entry = HdfsEntry.find(params[:id])
    present hdfs_entry, :presenter_options => {:deep => true}
  rescue HdfsEntry::HdfsContentsError
    json = {
        :response => Presenter.present(hdfs_entry, view_context),
        :errors => {:record => :HDFS_CONTENTS_UNAVAILABLE}
        }
    render json: json, status: :unprocessable_entity
  rescue Hdfs::PermissionDeniedError
    json = {
        :errors => {:record => :HDFS_KERBEROS_PERMISSION_DENIED}
    }
    render json: json, status: :unprocessable_entity
  end

  def update
    hdfs_entry = HdfsEntry.find(params[:id])

    hdfs_entry.metadata = params[:hdfs_entry][:metadata]
    hdfs_entry.save!

    present hdfs_entry, :presenter_options => {:deep => true}
  rescue Hdfs::PermissionDeniedError
    json = {
        :errors => {:record => :HDFS_KERBEROS_PERMISSION_DENIED}
    }
    render json: json, status: :unprocessable_entity
  end

  private

  def hdfs_data_source
    @hdfs_data_source ||= HdfsDataSource.find(params[:hdfs_data_source_id])
  end
end

# KT TODO: why not inherit from HdfsDataSourcesController?
module Api::Hdfs
  class FilesController < ApiController

    before_filter :check_source_disabled?

    def index
      begin
        if params[:id]
          hdfs_entries = HdfsEntry.where(:parent_id => params[:id])
          present hdfs_entries, :presenter_options => {:deep => true}
        else
          hdfs_entry = HdfsEntry.find_by_path_and_hdfs_data_source_id('/', hdfs_data_source.id)
          present hdfs_entry, :presenter_options => {:deep => true}
        end
      rescue ::Hdfs::PermissionDeniedError
        json = {
          :errors => {:record => :HDFS_KERBEROS_PERMISSION_DENIED}
        }
        render json: json, status: :unprocessable_entity
      end
    end

    def show
      begin
        hdfs_entry = HdfsEntry.find(params[:id])
        present hdfs_entry, :presenter_options => {:deep => true}
      rescue HdfsEntry::HdfsContentsError
        json = {
          :response => ApiPresenter.present(hdfs_entry, view_context),
          :errors => {:record => :HDFS_CONTENTS_UNAVAILABLE}
        }
        render json: json, status: :unprocessable_entity
      rescue ::Hdfs::PermissionDeniedError
        json = {
          :errors => {:record => :HDFS_KERBEROS_PERMISSION_DENIED}
        }
        render json: json, status: :unprocessable_entity
      end
    end

    private

    def check_source_disabled?
      Api::HdfsDataSourcesController.render_forbidden_if_disabled(hdfs_data_source)
    end

    def hdfs_data_source
      @hdfs_data_source ||= HdfsDataSource.find(params[:hdfs_data_source_id])
    end
  end
end

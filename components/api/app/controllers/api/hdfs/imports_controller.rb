# KT TODO: why not inherit from HdfsDataSourcesController?
module Api::Hdfs
  class ImportsController < ApiController
    wrap_parameters :hdfs_import, :exclude => []

    before_filter :check_source_disabled?

    def create
      Authorization::Authority.authorize! :create, upload, current_user, { :or => :current_user_is_objects_user }

      hdfs_import = HdfsImport.new(:hdfs_entry => hdfs_entry, :upload => upload, :file_name => file_name)
      hdfs_import.user = current_user
      hdfs_import.save!

      QC.enqueue_if_not_queued('Hdfs::ImportExecutor.run', hdfs_import.id, 'username' => current_user ? current_user.username : '')

      present hdfs_import, :status => :created
    end

    private

    def hdfs_entry
      @hdfs_entry ||= HdfsEntry.find params[:file_id]
    end

    def upload
      @upload ||= Upload.find hdfs_import_params[:upload_id]
    end

    def file_name
      hdfs_import_params[:file_name]
    end

    def hdfs_import_params
      params[:hdfs_import]
    end

    def check_source_disabled?
      Api::HdfsDataSourcesController.render_forbidden_if_disabled(HdfsDataSource.find(params[:hdfs_data_source_id]))
    end
  end
end

# KT TODO: why not inherit from HdfsDataSourcesController?
module Api::Hdfs
  class StatisticsController < ApiController

    before_filter :check_source_disabled?

    def show
      statistics = hdfs_entry.statistics

      present statistics
    end

    private

    def hdfs_entry
      @hdfs_entry ||= HdfsEntry.find(params[:file_id])
    end

    def hdfs_data_source
      @hdfs_data_source ||= HdfsDataSource.find(params[:hdfs_data_source_id])
    end

    def check_source_disabled?
      Api::HdfsDataSourcesController.render_forbidden_if_disabled(hdfs_data_source)
    end
  end
end
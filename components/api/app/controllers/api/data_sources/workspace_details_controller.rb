# KT TODO why not inherit from DataSourcesController?
module Api::DataSources
  class WorkspaceDetailsController < ApiController
    before_filter :check_source_disabled?

    def show
      data_source = DataSource.where(type: %w(GpdbDataSource PgDataSource)).find(params[:data_source_id])
      present data_source, :presenter_options => {:presenter_class => :DataSourceWorkspaceDetailPresenter}
    end

    def check_source_disabled?
      Api::DataSourcesController.render_forbidden_if_disabled(params)
    end
  end
end

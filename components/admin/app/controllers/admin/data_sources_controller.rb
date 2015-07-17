require_dependency 'admin/application_controller'

module Admin
  class DataSourcesController < ApplicationController
    layout 'admin/admin_lte_2'

    def index
      @data_sources = DataSource.paginate(:page => params[:page], :per_page => 10)
    end

    def show
      @data_source = DataSource.find_by_id(params[:id])
    end

  end
end
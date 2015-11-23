module Api
  class JdbcHiveDataSourcesController < ApiController

    wrap_parameters :jdbc_hive_data_source, :exclude => []

    before_filter :demo_mode_filter, :only => [:create, :update, :destroy]

    def create
      data_source = JdbcHive::DataSourceRegistrar.create!(params[:jdbc_hive_data_source], current_user)
      present data_source, :status => :created
    end

    def index
      succinct = params[:succinct] == 'true'
      includes = succinct ? [] : [{:owner => :tags}, :tags]
      data_sources = JdbcHiveDataSource.all.includes(includes)
      data_sources = JdbcHiveDataSource.filter_by_scope(current_user, data_sources) if current_user_in_scope?
      present paginate(data_sources), :presenter_options => {:succinct => succinct}
    end

    def show
      present JdbcHiveDataSource.find(params[:id])
    end

    def update
      gnip_params = params[:jdbc_hive_data_source]
      data_source = JdbcHiveDataSource.find(params[:id])
      Authorization::Authority.authorize! :update, data_source, current_user, {:or => :current_user_is_object_owner}
      data_source = JdbcHive::DataSourceRegistrar.update!(params[:id], gnip_params)

      present data_source
    end

    def destroy
      data_source = JdbcHiveDataSource.find(params[:id])
      Authorization::Authority.authorize! :update, data_source, current_user, {:or => :current_user_is_object_owner}
      data_source.destroy

      head :ok
    end
  end
end
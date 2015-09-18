module Api
  class GnipDataSourcesController < ApiController

    before_filter :demo_mode_filter, :only => [:create, :update, :destroy]
    before_filter :require_data_source_create, :only => [:create]

    def create
      data_source = Gnip::DataSourceRegistrar.create!(params[:gnip_data_source], current_user)
      present data_source, :status => :created
    end

    def index
      succinct = params[:succinct] == 'true'
      includes = succinct ? [] : [{:owner => :tags}, :tags]

      gnip_data_sources = GnipDataSource.all.includes(includes)
      #PT. Apply scope filter for current_user
      gnip_data_sources =GnipDataSource.filter_by_scope(current_user, gnip_data_sources) if current_user_in_scope?

      present paginate(gnip_data_sources), :presenter_options => {:succinct => succinct}
    end

    def show
      present GnipDataSource.find(params[:id])
    end

    def update
      gnip_params = params[:gnip_data_source]
      Authority.authorize! :update, GnipDataSource.find(params[:id]), current_user, {:or => :current_user_is_object_owner}
      data_source = Gnip::DataSourceRegistrar.update!(params[:id], gnip_params)

      present data_source
    end

    def destroy
      data_source = GnipDataSource.find(params[:id])
      Authority.authorize! :update, GnipDataSource.find(params[:id]), current_user, {:or => :current_user_is_object_owner}
      data_source.destroy

      head :ok
    end
  end
end
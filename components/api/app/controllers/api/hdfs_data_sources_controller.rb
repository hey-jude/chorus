module Api
  class HdfsDataSourcesController < ApiController

    before_filter :demo_mode_filter, :only => [:create, :update, :destroy]
    before_filter :find_data_source, :except => [:index, :create]
    before_filter :hide_disabled_source, :only => [:show, :update]

    def create
      data_source = ::Hdfs::DataSourceRegistrar.create!(params[:hdfs_data_source], current_user)
      QC.enqueue_if_not_queued("HdfsDataSource.refresh", data_source.id)
      present data_source, :status => :created
    end

    def index
      succinct = params[:succinct] == 'true'
      includes = succinct ? [] : [{:owner => :tags}, :tags]
      hdfs_data_sources = HdfsDataSource.all.includes(includes)
      hdfs_data_sources = hdfs_data_sources.with_job_tracker if params[:job_tracker]
      #PT. Apply scope filter for current_user
      hdfs_data_sources = hdfs_data_sources.reject{ |data_source| data_source.disabled? } if params["filter_disabled"] == "true"

      hdfs_data_sources = HdfsDataSource.filter_by_scope(current_user, hdfs_data_sources) if current_user_in_scope?

      present paginate(hdfs_data_sources), :presenter_options => {:succinct => succinct}
    end

    def show
      present @hdfs_data_source
    end

    def update
      Authorization::Authority.authorize! :update, @hdfs_data_source, current_user, {:or => :current_user_is_object_owner}

      @hdfs_data_source = ::Hdfs::DataSourceRegistrar.update!(@hdfs_data_source.id, params[:hdfs_data_source], current_user)
      present @hdfs_data_source
    end

    def destroy
      Authorization::Authority.authorize! :update, @hdfs_data_source, current_user, {:or => :current_user_is_object_owner}
      @hdfs_data_source.destroy
      head :ok
    end

    def self.render_forbidden_if_disabled(hdfs_data_source)
      raise Authorization::AccessDenied.new("Forbidden", :data_source, nil) if hdfs_data_source.state == 'disabled'
    end

    private

    def find_data_source
      @hdfs_data_source = HdfsDataSource.find(params[:id])
    end

    def hide_disabled_source
      if !Authorization::Permissioner.is_admin?(current_user) &&
        @hdfs_data_source.disabled? &&
        @hdfs_data_source.owner != current_user
        raise ActiveRecord::RecordNotFound
      end
    end
  end
end
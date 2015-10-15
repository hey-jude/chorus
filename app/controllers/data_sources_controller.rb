class DataSourcesController < ApplicationController
  include DataSourceAuth

  wrap_parameters :data_source, :exclude => []

  before_filter :find_data_source, :only => [:show, :update, :destroy]
  before_filter :hide_disabled_source, :only => [:show, :update]
  before_filter :demo_mode_filter, :only => [:create, :update, :destroy]
  before_filter :require_data_source_create, :only => [:create]

  def index
    succinct = params[:succinct] == 'true'
    includes = succinct ? [] : [{:owner => :tags}, :tags]
    data_sources = DataSource.by_type(params[:entity_type]).includes(includes)
    data_sources = data_sources.accessible_to(current_user) unless params[:all]

    data_sources = data_sources.reject{ |data_source| data_source.disabled? } if params["filter_disabled"] == "true"
    #PT. Apply scope filter for current_user
    data_sources = DataSource.filter_by_scope(current_user, data_sources) if current_user_in_scope?
    present paginate(data_sources), :presenter_options => {:succinct => succinct}
  end

  def show
    Authority.authorize! :show, @data_source, current_user, { :or => :data_source_is_shared }
    present @data_source
  end

  def create
    entity_type = params[:data_source].delete(:entity_type)
    data_source = DataSource.create_for_entity_type(entity_type, current_user, params[:data_source])
    data_source.check_status!
    present data_source, :status => :created
  end

  def update
    Authority.authorize! :update, @data_source, current_user, { :or => :current_user_is_object_owner }
    @data_source.assign_attributes(params[:data_source])

    @data_source.save_if_incomplete!(params[:data_source])
    present @data_source
  end

  def destroy
    Authority.authorize! :destroy, @data_source, current_user, { :or => :current_user_is_object_owner }
    @data_source.destroy
    head :ok
  end

  def self.render_forbidden_if_disabled(params)
    raise Authority::AccessDenied.new("Forbidden", :data_source, nil) if DataSource.find(params[:data_source_id]).disabled?
  end

  private

  def find_data_source
    @data_source = DataSource.find(params[:id])
  end

  def hide_disabled_source
    raise ActiveRecord::RecordNotFound if hide_data_source?
  end

  def hide_data_source?
    !Permissioner.is_admin?(current_user) && @data_source.disabled? && @data_source.owner != current_user
  end
end

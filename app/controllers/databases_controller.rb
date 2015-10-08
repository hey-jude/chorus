class DatabasesController < ApplicationController
  include DataSourceAuth
  before_filter :check_source_disabled?

  def index
    databases = Database.visible_to(authorized_account(data_source))

    databases = Database.filter_by_scope(current_user, databases) if current_user_in_scope?
    present paginate databases
  end

  def show
    database = Database.find(params[:id])
    authorize_data_source_access(database)
    present database
  end

  private

  def data_source
    DataSource.where(:type => %w(GpdbDataSource PgDataSource)).find(params[:data_source_id])
  end

  def check_source_disabled?
    ::DataSourcesController.render_forbidden_if_disabled(params)
  end
end

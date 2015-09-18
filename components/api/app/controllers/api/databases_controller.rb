module Api
  class DatabasesController < ApiController
    include DataSourceAuth

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
  end
end
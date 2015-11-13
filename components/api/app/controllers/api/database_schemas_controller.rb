module Api
  class DatabaseSchemasController < ApiController
    include DataSourceAuth

    def index
      database = Database.find(params[:database_id])
      schemas = Schema.visible_to(authorized_account(database), database)
      schemas = Schema.filter_by_scope(current_user, schemas) if current_user_in_scope?
      present paginate schemas
    end
  end
end
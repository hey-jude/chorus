module DataSources
  class SchemasController < DataSourcesController
    def index
      data_source = DataSource.find(params[:data_source_id])
      schemas = Schema.visible_to(authorized_account(data_source), data_source)
      schemas = Schema.filter_by_scope(current_user, schemas) if current_user_in_scope?
      present schemas
    end
  end
end
class SchemasController < ApplicationController
  include DataSourceAuth

  def show
    schema = Schema.find(params[:id])
    authorize_data_source_access(schema)
    raise Authority::AccessDenied.new("Forbidden", :data_source, nil) if schema.data_source.state == 'disabled'
    schema.verify_in_source(current_user)

    present schema
  end
end

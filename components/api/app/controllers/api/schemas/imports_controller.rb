# KT TODO: why not inherit from SchemasController?
module Api::Schemas
  class ImportsController < ApiController
    wrap_parameters :dataset_import, :exclude => [:id]

    before_filter :demo_mode_filter, :only => [:create]

    def create
      import_params = params[:dataset_import]
      schema = GpdbSchema.find(params[:schema_id])
      import = schema.imports.new(import_params)
      import.user = current_user
      import.source_dataset = Dataset.find(import_params[:dataset_id])
      import.save!

      import.enqueue_import

      render :json => {}, :status => :created
    end
  end
end
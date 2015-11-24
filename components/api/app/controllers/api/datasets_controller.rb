module Api
  class DatasetsController < ApiController

    def index
      schema = Schema.find(params[:schema_id])
      account = authorized_account(schema)

      options = {}
      options[:name_filter] = params[:filter] if params[:filter]
      options[:tables_only] = params[:tables_only] if params[:tables_only]

      refresh_options = options.merge(:limit => params[:page].to_i * params[:per_page].to_i, :skip_dataset_solr_index => true)
      datasets = schema.refresh_datasets(account, refresh_options).includes(Dataset.eager_load_associations)
      params.merge!(:total_entries => schema.dataset_count(account, options))

      datasets = Dataset.filter_by_scope(current_user, datasets) if current_user_in_scope?
      present paginate(datasets)
    end

    def show
      data_set = Dataset.find(params[:id])
      authorize_data_source_access(data_set)
      raise Authorization::AccessDenied.new("Forbidden", :data_source, nil) if data_set.data_source.state == 'disabled'
      dataset = Dataset.find_and_verify_in_source(params[:id].to_i, current_user)
      present dataset, params
    end
  end
end
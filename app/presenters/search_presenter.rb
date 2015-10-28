class SearchPresenter < SearchPresenterBase

  def to_hash
    data_source_results = present_models_with_highlights(model.data_sources).compact

    {
        :users => {
            :results => present_models_with_highlights(model.users),
            :numFound => model.num_found[:users]
        },

        :data_sources => {
            :results => data_source_results,
            :numFound => data_source_results.length
        },

        :workspaces => {
            :results => present_models_with_highlights(model.workspaces),
            :numFound => model.num_found[:workspaces]
        },

        :workfiles => {
            :results => present_models_with_highlights(model.workfiles),
            :numFound => model.num_found[:workfiles]
        },

        :datasets => {
            :results => present_models_with_highlights(model.datasets),
            :numFound => model.num_found[:datasets]
        },

        :hdfs_entries => {
            :results => present_models_with_highlights(model.hdfs_entries),
            :numFound => model.num_found[:hdfs_entries]
        },

        :other_files => {
            :results => present_models_with_highlights(model.attachments),
            :numFound => model.num_found[:attachments]
        }
    }.merge(workspace_specific_results)
  end


  def self.filter_disabled(data_source_results)
    data_source_results.select { |ds| ds.state != 'disabled' && ds.state != 'incomplete' }
  end

  private

  def workspace_specific_results
    return {} unless model.workspace_id
    {
        :this_workspace => {
            :results => present_workspace_models_with_highlights(model.this_workspace),
            :numFound => model.num_found[:this_workspace]
        }
    }
  end
end

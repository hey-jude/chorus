module Api
  class WorkspaceDatasetsController < ApiController

    def index
      Authorization::Authority.authorize! :show, workspace, current_user, {:or => [:current_user_is_in_workspace,
                                                                    :workspace_is_public]}

      params[:limit] = params[:page].to_i * params[:per_page].to_i
      params[:name_filter] = params[:name_pattern]
      params[:total_entries] = workspace.dataset_count(current_user, params)

      @datasets = workspace.datasets(current_user, params).includes(Dataset.eager_load_associations).list_order
      @options = {:workspace => workspace, :user => current_user, :rendering_activities => true, :show_latest_comments => false}

      #Added caching options to speed up page load time. Prakash 1/15/15
      namespace = workspace ? "workspace:#{workspace.id}:datasets" : "workspace:datasets"

      present paginate(@datasets), :presenter_options => {:workspace => workspace, :cached => false, :namespace => namespace}

    end

    def create
      Authorization::Authority.authorize! :update, workspace, current_user, { :or => :can_edit_sub_objects }

      datasets = Dataset.where(:id => params[:dataset_ids])
      raise_denied if datasets.any?{ |dataset| dataset.data_source.disabled? }

      status = workspace.associate_datasets(current_user, datasets) ? :created : :unprocessable_entity

      render :json => {}, :status => status
    end

    def show
      Authorization::Authority.authorize! :show, workspace, current_user, {:or => [:current_user_is_in_workspace,
                                                                    :workspace_is_public]}

      dataset = params[:name] ? Dataset.find_by_name(params[:name]) : Dataset.find(params[:id])
      dataset.in_workspace?(workspace) or raise ActiveRecord::RecordNotFound
      raise ActiveRecord::RecordNotFound if dataset.data_source.disabled?

      authorize_data_source_access(dataset)

      if dataset.verify_in_source(current_user)
        dataset.mark_fresh!
        present dataset, {:presenter_options => {:workspace => workspace, :with_content => true}}
      else
        render_dataset_with_error(dataset)
      end

    rescue PostgresLikeConnection::DatabaseError => e
      render_dataset_with_error(dataset, e.error_type)
    end

    def render_dataset_with_error(dataset, error_type = :MISSING_DB_OBJECT)
      json = {
        :response => ApiPresenter.present(dataset, view_context, {:workspace => workspace}),
        :errors => {:record => error_type}
      }
      render json: json, status: :unprocessable_entity
    end

    def destroy_multiple
      Authorization::Authority.authorize! :update, workspace, current_user, {:or => :can_edit_sub_objects}

      datasets = Dataset.where(:id => params[:dataset_ids])
      raise_denied if datasets.any?{ |dataset| dataset.data_source.disabled? }

      associations = AssociatedDataset.where(:workspace_id => params[:workspace_id], :dataset_id => params[:dataset_ids])
      associations.destroy_all
      render :json => {}
    end

    def destroy
      Authorization::Authority.authorize! :update, workspace, current_user, {:or => :can_edit_sub_objects}
      raise_denied if Dataset.find(params[:id]).data_source.disabled?

      associations = AssociatedDataset.where(:workspace_id => params[:workspace_id], :dataset_id => [params[:id]])
      associations.destroy_all
      render :json => {}
    end

    private

    def raise_denied
      raise Authorization::AccessDenied.new("Forbidden", :data_source, nil)
    end

    def workspace
      @workspace ||= Workspace.workspaces_for(current_user).find(params[:workspace_id])
    end
  end
end
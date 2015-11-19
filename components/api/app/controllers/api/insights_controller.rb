module Api
  class InsightsController < ApiController
    wrap_parameters :insight, :exclude => []

    def create
      event = Events::Base.visible_to(current_user).find(note_id)
      if event.is_a?(Events::WorkletResultShared) || event.is_a?(Events::Note)
        event.promote_to_insight
        present event, :status => :created
      else
        raise ApiValidationError.new(:base, :generic, {:message => "Event cannot become an insight"})
      end
    end

    def destroy
      event = Events::Base.visible_to(current_user).find params[:id]
      Authority.authorize! :update, event, current_user, {:or => [:current_user_promoted_note,
                                                                  :current_user_is_notes_workspace_owner]}
      event.demote_from_insight
      present event
    end

    def publish
      event = Events::Base.visible_to(current_user).find(note_id)
      raise ApiValidationError.new(:base, :generic, {:message => "Note has to be an insight first"}) unless event.insight
      event.set_insight_published true
      present event, :status => :created
    end

    def unpublish
      event = Events::Base.find(note_id)
      #authorize! :update, note
      Authority.authorize! :update, event, current_user, {:or => :current_user_is_event_actor}
      raise ApiValidationError.new(:base, :generic, {:message => "Note has to be published first"}) unless event.published
      event.set_insight_published false
      present event, :status => :created
    end

    def index
      params[:entity_type] ||= 'dashboard'
      insights = get_insights
      # TODO: Scope. Filter results for curret_user's scope
      insights = Events::Base.filter_by_scope(current_user, insights) if current_user_in_scope?

      present paginate(insights), :presenter_options => {:activity_stream => true, :cached => true, :namespace => "workspace:insights"}
    end

    private

    def note_id
      params[:insight].try(:[], :note_id) || params[:note].try(:[], :note_id)
    end

    def get_insights
      insight_query = Events::Base.where(insight: true).order("events.id DESC")

      if params[:entity_type] == "workspace"
        workspace = Workspace.find(params[:entity_id])
        insight_query = insight_query.where(workspace_id: workspace.id)
      end

      if (workspace && !workspace.public?) || params[:entity_type] != "workspace"
        insight_query = insight_query.visible_to(current_user) unless current_user.admin?
      end

      insight_query = insight_query.includes(Events::Base.activity_stream_eager_load_associations)
      insight_query
    end
  end
end
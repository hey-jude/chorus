class InsightsController < ApplicationController
  wrap_parameters :insight, :exclude => []
  
  def create
    note_id = params[:insight][:note_id] || params[:note][:note_id]
    note = Events::Note.visible_to(current_user).find(note_id)
    note.promote_to_insight
    present note, :status => :created
  end

  def destroy
    note = Events::Note.visible_to(current_user).find params[:id]
    Authority.authorize! :update, note, current_user, {:or => [:current_user_promoted_note,
                                                                            :current_user_is_notes_workspace_owner]}
    note.demote_from_insight
    present note
  end

  def publish
    note_id = params[:insight][:note_id] || params[:note][:note_id]
    note = Events::Note.visible_to(current_user).find(note_id)
    raise ApiValidationError.new(:base, :generic, {:message => "Note has to be an insight first"}) unless note.insight
    note.set_insight_published true
    present note, :status => :created
  end

  def unpublish
    note_id = params[:insight][:note_id] || params[:note][:note_id]
    note = Events::Note.find(note_id)
    #authorize! :update, note
    Authority.authorize! :update, note, current_user, { :or => :current_user_is_event_actor }
    raise ApiValidationError.new(:base, :generic, {:message => "Note has to be published first"}) unless note.published
    note.set_insight_published false
    present note, :status => :created
  end

  def index
    params[:entity_type] ||= 'dashboard'
    insights = get_insights
    # TODO: Scope. Filter results for curret_user's scope
    insights = Events::Base.filter_by_scope(current_user, insights) if current_user_in_scope?

    present paginate(insights), :presenter_options => {:activity_stream => true, :cached => true, :namespace => "workspace:insights"}
  end

  private

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

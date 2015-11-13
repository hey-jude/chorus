module Api
  class EventsController < ApiController
    def index
      events = case params[:entity_type]
                 when 'dashboard'
                   Events::Base.for_dashboard_of(current_user)
                 when 'user'
                   ModelMap.
                     model_from_params(params[:entity_type], params[:entity_id]).
                     accessible_events(current_user)
                 else
                   model = ModelMap.model_from_params(params[:entity_type], params[:entity_id])
                   Authority.authorize! :show, model, current_user, {:or => :handle_legacy_show} unless model.is_a?(PublishedWorklet)
                   model.events
               end

      events = events.includes(Events::Base.activity_stream_eager_load_associations).order('events.id DESC')
      if params[:results_only]
        events = events.where(:action => Events::WorkfileResult)
      end
      if params[:current_user_only]
        events = events.where(:actor_id => current_user.id)
      end
      #@options =  { :workspace => workspace , :user => current_user, :rendering_activities => true, :show_latest_comments => false}
      #TODO Scope Filter results for current user's scope
      events = Events::Base.filter_by_scope(current_user, events) if current_user_in_scope?
      present paginate(events), :presenter_options => {:activity_stream => true, :succinct => true,
                                                       :workfile_as_latest_version => true, :cached => true, :namespace => 'activities'}

      # KT TODO cleanup: delete this

      # response = render_to_string :index, :formats => [:json]
      # json = JSON.parse(response)
      # if @events.respond_to? :current_page
      # json[:pagination] = {
      #      :page => @events.current_page,
      #      :per_page => @events.per_page,
      #      :records => @events.total_entries,
      #      :total => @events.per_page > 0 ? @events.total_pages : nil
      # }
      # end
      #
      # render :json => json

    end

    def show
      present Events::Base.visible_to(current_user).find(params[:id]), :presenter_options => {:activity_stream => true, :succinct => true}
    end
  end
end
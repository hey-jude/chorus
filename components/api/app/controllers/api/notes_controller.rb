module Api
  class NotesController < ApiController
    include ActionView::Helpers::SanitizeHelper

    def create
      note_params = params[:note]
      entity_type = note_params[:entity_type]
      entity_id = note_params[:entity_id]
      model = ModelMap.model_from_params(entity_type, entity_id)
      Authority.authorize! :show, model, current_user, {:or => :handle_legacy_show}

      note_params[:body] = sanitize(note_params[:body])

      note = Events::Note.build_for(model, note_params)

      note.save!

      (note_params[:recipients] || []).each do |recipient_id|
        Notification.create!(:recipient_id => recipient_id, :event_id => note.id)
      end

      present note, :status => :created
    end

    def update
      note = Events::Base.find(params[:id])

      Authority.authorize! :update, note, current_user, {:or => :current_user_is_event_actor}
      note.update_attributes!(:body => sanitize(params[:note][:body]))
      present note
    end

    def destroy
      note = Events::Base.find(params[:id])
      #authorize! :destroy, note
      Authority.authorize! :destroy, note, current_user, {:or => [:current_user_is_notes_workspace_owner,
                                                                  :current_user_is_event_actor]}
      note.destroy
      render :json => {}
    end
  end
end
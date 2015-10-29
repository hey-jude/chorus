module Api
  class AttachmentsController < ApiController
    def create
      event = Events::Base.find(params[:note_id])

      Authority.authorize! :create_attachment_on, event, current_user, {:or => :current_user_is_event_actor}

      if params[:contents]
        attachment_content = params[:contents]
      else
        if defined?(VisLegacy::Engine)
          transcoder = SvgToPng.new(params[:svg_data])
          attachment_content = transcoder.fake_uploaded_file(params[:file_name])
        else
          raise "No Visualization component attached."
        end
      end
      event.attachments.create!(:contents => attachment_content)
      event.reload
      present event
    end

    def show
      attachment = Attachment.find(params[:id])
      Authority.authorize! :show, attachment.note.note_target, current_user, {:or => :handle_legacy_show}
      send_file(attachment.contents.path(params[:style]), :type => attachment.contents_content_type, :disposition => 'inline')
      ActiveRecord::Base.connection.close
    end
  end
end
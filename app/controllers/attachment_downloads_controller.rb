class AttachmentDownloadsController < ApplicationController

  def show
    attachment = Attachment.find(params[:attachment_id])
    Authority.authorize! :show, attachment.note, current_user, { :or => :current_user_can_view_note_target }
    #authorize! :show, attachment.note

    download_file(attachment)
  end

  private

  def download_file(attachment)
    send_file attachment.contents.path, :disposition => 'attachment'
    ActiveRecord::Base.connection.close
  end
end

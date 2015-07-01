class AttachmentDownloadsController < ApplicationController

  def show
    attachment = Attachment.find(params[:attachment_id])
    Authority.authorize! :show, attachment.note.note_target, current_user, { :or => :handle_legacy_show }

    download_file(attachment)
  end

  private

  def download_file(attachment)
    send_file attachment.contents.path, :disposition => 'attachment'
    ActiveRecord::Base.connection.close
  end
end

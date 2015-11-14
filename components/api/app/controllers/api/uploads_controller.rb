module Api
  class UploadsController < ApiController

    def create
      upload = Upload.new(contents: params[:contents])
      upload.user = current_user
      upload.save!

      present upload, :status => :created
    end
  end
end
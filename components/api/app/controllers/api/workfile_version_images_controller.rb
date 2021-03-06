# KT TODO: why not inherit from ImagesController?
module Api
  class WorkfileVersionImagesController < ApiController

    def show
      workfile_version = WorkfileVersion.find(params[:workfile_version_id])
      Authorization::Authority.authorize! :show,
                           workfile_version.workfile.workspace,
                           current_user,
                           {:or => [:current_user_is_in_workspace,
                                    :workspace_is_public]}
      style = params[:style] ? params[:style] : 'original'
      content_type = workfile_version.contents_content_type
      file_path = workfile_version.contents.path(style)
      send_file file_path, :type => content_type
      ActiveRecord::Base.connection.close
    end
  end
end
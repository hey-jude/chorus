module Api
  class WorkfileVersionsController < ApiController
    before_filter :find_workfile
    before_filter :authorize_sub_objects, :only => [:update, :create, :destroy]
    before_filter :authorize_show_workfile, :only => [:show, :index]

    wrap_parameters :workfile, :exclude => []

    def update
      workfile_version = @workfile.versions.find(params[:id])

      workfile_version.update_content(params[:workfile][:content])
      @workfile.remove_draft(current_user)

      present @workfile.latest_workfile_version, :presenter_options => {:contents => true}
    end

    def create
      @workfile.create_new_version(current_user, params[:workfile])
      present @workfile.latest_workfile_version, :presenter_options => {:contents => true}, :status => :created
    end

    def show
      workfile_version = @workfile.versions.find(params[:id])
      present workfile_version, :presenter_options => {:contents => true}
    end

    def index
      present paginate(@workfile.versions)
    end

    def destroy
      workfile_versions = @workfile.versions
      workfile_version = workfile_versions.find(params[:id])
      version_num = workfile_version.version_num

      Workfile.transaction do
        if workfile_versions.length == 1
          raise ApiValidationError.new(:base, :only_one_version)
        elsif @workfile.latest_workfile_version_id == params[:id].to_i
          workfile_version.destroy
          @workfile.update_attributes!({:latest_workfile_version_id => workfile_versions[1].id}, :without_protection => true)
        else
          workfile_version.destroy
        end

        Events::WorkfileVersionDeleted.by(current_user).add(
          :workfile => @workfile,
          :workspace => @workfile.workspace,
          :version_num => version_num
        )

      end

      render :json => {}
    end

    private

    def find_workfile
      @workfile = Workfile.find(params[:workfile_id])
    end

    def authorize_sub_objects
      Authorization::Authority.authorize! :update, @workfile.workspace, current_user, {:or => :can_edit_sub_objects}
    end

    def authorize_show_workfile
      Authorization::Authority.authorize! :show, @workfile.workspace, current_user, {:or => :handle_legacy_show}
    end

  end
end
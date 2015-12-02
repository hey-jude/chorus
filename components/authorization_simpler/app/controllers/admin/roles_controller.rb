module Admin
  class RolesController < AdminController
    add_breadcrumb "Admin", :root_path

    def index
      add_breadcrumb "Roles", roles_path
      @roles = Authorization::ROLES
    end

    def show
      add_breadcrumb "Roles", roles_path
      @role_title = params[:id]
      @role_details = Authorization::ROLE_PERMISSIONS[params[:id]]
      add_breadcrumb "Role: #{@role_title}", role_path(params[:id])
    end
  end
end
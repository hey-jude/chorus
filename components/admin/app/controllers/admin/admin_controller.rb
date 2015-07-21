require_dependency 'admin/application_controller'

module Admin
  class AdminController < ApplicationController
    layout 'admin/admin_lte_2'

 #   add_breadcrumb "admin", "admin.admins_path".to_sym

    def index
      @users_count = User.count
      @teams_count = Group.count
      @datasources_count = DataSource.count
      @scopegroups_count = ChorusScope.count
      @jobs_count = Job.count

    end

  end
end
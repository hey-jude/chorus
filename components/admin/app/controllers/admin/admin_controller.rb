require_dependency 'admin/application_controller'

module Admin
  class AdminController < ApplicationController
    layout 'admin/admin_lte_2'

    #respond_to :html, :js, :json

    def index
      @users_count = User.count
      @teams_count = Group.count
      @datasources_count = DataSource.count
      @scopegroups_count = nil
      @jobs_count = Job.count

    end

  end
end
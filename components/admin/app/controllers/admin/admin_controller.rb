require_dependency 'admin/application_controller'

module Admin
  class AdminController < ApplicationController
    layout 'admin/admin_lte_2'


    def index
      @users_count = User.count
      @teams_count = Group.count
      @datasources_count = DataSource.count
      @scopegroups_count = ChorusScope.count
      @jobs_count = Job.count
    end

    def licence_info

    end

    def email_config

    end

    def auth_config

    end

    def general_settings

    end

    def app_preferences

    end

    def default_settings

    end

    def workflow_editor_pref

    end

    def manage_tags

    end


  end
end
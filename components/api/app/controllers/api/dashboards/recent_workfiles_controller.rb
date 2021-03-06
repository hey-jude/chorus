# KT TODO why not inherit from DashboardsController?
module Api::Dashboards
  class RecentWorkfilesController < ApiController
    wrap_parameters :recent_workfiles

    def create
      if (params[:recent_workfiles][:action] == 'updateOption')
        option_value = params[:recent_workfiles][:option_value]
        config = DashboardConfig.new(current_user)
        config.set_options('RecentWorkfiles', option_value)
      elsif (params[:recent_workfiles][:action] == 'clearList')
        OpenWorkfileEvent.where(:user_id => current_user).destroy_all
      end
      render :json => {}
    end
  end

end

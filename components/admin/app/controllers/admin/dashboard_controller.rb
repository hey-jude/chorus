module Admin
  class DashboardController < AdminController

    def index
      add_breadcrumb "Admin", :root_path
    end
  end
end
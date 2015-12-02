module Admin
  class LicensesController < AdminController
    add_breadcrumb "Admin", :root_path

    def show
      add_breadcrumb "License", license_path
      @license = License.instance
    end
  end
end
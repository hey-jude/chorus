require_dependency 'admin/application_controller'

module Admin
  class AdminController < ApplicationController
    layout 'admin/admin_lte_2'

    #respond_to :html, :js, :json

    def index

    end

  end
end
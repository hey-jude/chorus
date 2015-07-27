require_dependency 'admin/application_controller'

module Admin
  class ScopesController < ApplicationController
    layout 'admin/admin_lte_2'

    def index
      @scopes = ChorusScope.paginate(:page => params[:page], :per_page => 10)
    end

    def show
      @scope = ChorusScope.find_by_id(params[:id])
    end

    def new
      @scope = ChorusScope.new
    end

    def create
      @scope = ChorusScope.new(params[:scope])
      if @scope.save
        @error = nil
      else
        @error = true
      end
    end

  end
end
require_dependency 'admin/application_controller'

module Admin
  class TeamsController < ApplicationController
    layout 'admin/admin_lte_2'

    def index
      @teams = Group.paginate(:page => params[:page], :per_page => 10)
    end

    def show
      @team = Group.find_by_id(params[:id])
    end

    def new
      @group = Group.new
    end

    def create
      @team = Group.new(params[:group])
      if @team.save
        @error = nil
      else
        @error = true
      end
    end

  end
end
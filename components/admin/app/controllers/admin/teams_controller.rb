require_dependency 'admin/application_controller'

module Admin
  class TeamsController < ApplicationController
    layout 'admin/admin_lte_2'

    def index
      @teams = Group.paginate(:page => params[:page], :per_page => 10).order('name')
    end

    def show
      @team = Group.find(params[:id])
      @team_users = @team.users.paginate(:page => params[:users_page], :per_page => 10)
      @team_roles = @team.roles.paginate(:page => params[:roles_page], :per_page => 10)
      @team_scopes = @team.chorus_scopes.paginate(:page => params[:scopes_page], :per_page => 10)
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

    def edit
      @group = Group.find_by_id(params[:id])

    end

    def update
      @group = Group.find(params[:id])
      if @group.update_attributes(params[:group])
        @error = nil
      else
        @error = true
      end
    end

    def manage_memberships

    end

    def manage_roles

    end

    def manage_scopes

    end

    def manage_workspaces

    end




  end
end
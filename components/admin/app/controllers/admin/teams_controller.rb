require_dependency 'admin/application_controller'

module Admin
  class TeamsController < ApplicationController
    layout 'admin/admin_lte_2'

    def index
     get_teams
    end

    def show
      @team = Group.find(params[:id])
      @teams = Group.where("id <> ?", params[:id])
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

    def destroy
      @team = Group.find(params[:id])
      if params[:teams_select] == "delete"
        if @team.destroy
          get_teams
          @error = nil
        else
          @error = true
        end
      elsif params[:teams_select] = "move_to_another"
        new_team_id = params[:new_team_id]
        if @team.move_members_to_another_team(new_team_id)
          @team.destroy
          get_teams
          @error = nil
        else
          @error = true
        end
      end
    end

    def manage_memberships
      @team = Group.find(params[:id])
      @team_members = @team.users
      @available_members = User.all - @team.users
    end

    def update_memberships
      @team = Group.find(params[:id])
       members = params[:items]
       @change_count = members.count - @team.users.count
       @team.users.destroy_all
       members.each do |member_id|
         @team.users << User.find(member_id)
       end
      @team_members = @team.users
      @available_members = User.all - @team.users
    end

    def manage_roles
      @team = Group.find(params[:id])
      @team_roles = @team.roles
      @available_roles = Role.all - @team.roles
    end

    def update_roles
      @team = Group.find(params[:id])
      roles = params[:items]
      @change_count = roles.count - @team.roles.count
      @team.roles.destroy_all
      roles.each do |role_id|
        @team.roles << Role.find(role_id)
      end
      @team_roles = @team.roles
      @available_roles = Role.all - @team.roles

    end

    def manage_scopes
      @team = Group.find(params[:id])
      @team_scopes = @team.chorus_scopes
      @available_scopes = ChorusScope.all -  @team.chorus_scopes

    end

    def update_scopes
      @team = Group.find(params[:id])
      @team_scopes = @team.chorus_scopes
      @available_scopes = ChorusScope.all -  @team.chorus_scopes

    end


    def manage_workspaces
      @team = Group.find(params[:id])

    end

   private

    def get_teams
      @teams = Group.paginate(:page => params[:page], :per_page => 10).order('name')
    end


  end
end
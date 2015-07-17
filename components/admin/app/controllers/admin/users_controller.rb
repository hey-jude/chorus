require_dependency 'admin/application_controller'

module Admin
  class UsersController < ApplicationController
    before_filter :load_user,  only: [:show, :update, :destroy]


    layout 'admin/admin_lte_2'
    def index
      @users = User.paginate(:page => params[:page], :per_page => 10)
      # TODO Need to understand how to fetch users with corect scope
      #@users = User.filter_by_scope(current_user, users) if ::current_user_in_scope?
    end

    def show

    end


    private

    def load_user
      @user = User.find(params[:id])
    end

  end
end
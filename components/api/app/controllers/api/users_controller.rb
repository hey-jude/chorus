module Api
  class UsersController < ApiController
    before_filter :load_user, :only => [:show, :update, :destroy]

    wrap_parameters :exclude => []

    def index
      users = User.order(params[:order]).includes(:tags)
      users = User.filter_by_scope(current_user, users) if current_user_in_scope?
      present paginate(users)
    end

    def show
      present @user
    end

    def create
      user = User.new
      user.attributes = user_params

      # KT TODO remove these lines when Roles are fully implemented
      if user_params.key?(:admin)
        user.admin = user_params[:admin]
        if defined?(Authorization::Engine)
          user_params[:admin] ? user.add_role('admin') : user.remove_role('admin')
        end
      end

      if user_params.key?(:developer)
        user.developer = user_params[:developer]

        # KT TODO: we need to define what the 'developer' role is in lib/authorization.rb
        # if defined?(Authorization::Engine)
        #   user_params[:developer] ? user.add_role('developer') : user.remove_role('developer')
        # end
      end

      User.transaction do
        user.save!
        Events::UserAdded.by(current_user).add(:new_user => user)
      end

      present user, :status => :created
    end

    def update
      UserUpdateService.new(actor: current_user, target: @user).update!(user_params)
      present @user
    end

    def destroy
      @user.destroy
      render :json => {}
    end

    def ldap
      users = LdapClient.search(params[:username]).map do |userJson|
        User.new userJson
      end
      present users
    end

    private

    def load_user
      @user = User.find(params[:id])
    end

    def user_params
      @user_params ||= params[:user]
    end

  end
end
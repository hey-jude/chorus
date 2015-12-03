module Api
  class UsersController < ApiController
    before_filter :load_user, :only => [:show, :update, :destroy]
    before_filter :require_not_current_user, :only => [:destroy]
    before_filter :authorize, :only => [:create, :destroy, :ldap, :update]

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
      # remove these lines when Roles are fully implemented
      user.admin = user_params[:admin] if user_params.key?(:admin)
      user.developer = user_params[:developer] if user_params.key?(:developer)
      user.user_type = user_params[:user_type] if user_params.key?(:user_type)
      User.transaction do
        user.save!
        default_group = Group.find_by_name('default_group')
        # Add user to the default group
        user.groups << default_group unless user.groups.include? default_group
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

    def require_not_current_user
      render_forbidden if current_user.id == @user.id
    end

    def user_params
      @user_params ||= params[:user]
    end

    def authorize
      user_object = @user || User.new

      if action_name.to_sym == :update
        options = {:or => :current_user_is_referenced_user}
      end

      Authorization::Authority.authorize! action_name.to_sym, user_object, current_user, options
    end

  end
end
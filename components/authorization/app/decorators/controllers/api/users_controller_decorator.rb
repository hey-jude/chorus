Api::UsersController.class_eval do
  before_filter :authorize, :only => [:create, :destroy, :ldap, :update]
  before_filter :require_not_current_user, :only => [:destroy]

  private

  def require_not_current_user
    render_forbidden if current_user.id == @user.id
  end

  def authorize
    user_object = @user || User.new

    if action_name.to_sym == :update
      options = {:or => :current_user_is_referenced_user}
    end

    Authorization::Authority.authorize! action_name.to_sym, user_object, current_user, options
  end
end

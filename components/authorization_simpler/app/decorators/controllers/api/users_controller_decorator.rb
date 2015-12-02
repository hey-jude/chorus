Api::UsersController.class_eval do
  before_filter :authorize, :only => [:create, :destroy, :ldap, :update]

  private

  def authorize
    unless passes_controller_authorization? || passes_role_based_authorization?(@user)
      raise_access_denied(params[:action], @user)
    end
  end

  def current_user_is_admin
    logged_in? && current_user.admin?
  end

  def current_user_is_admin_or_self
    logged_in? && (current_user.admin? || current_user == @user)
  end

  def current_user_is_not_destroyed_user
    current_user.id != @user.id
  end

  def passes_controller_authorization?
    case params[:action].to_sym
      when :create, :ldap
        return current_user_is_admin
      when :update
        return current_user_is_admin_or_self
      when :destroy
        return current_user_is_admin && current_user_is_not_destroyed_user
      else
        true
    end
  end
end
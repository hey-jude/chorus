ApiController.class_eval do
  #PT Method to check if current user is in scope
  def current_user_in_scope?
    if Permissioner.is_admin?(current_user)
      return false
    else
      Permissioner.user_in_scope?(current_user)
    end
  end

  def current_user_is_admin?
    Permissioner.is_admin?(current_user)
  end

  def require_data_source_create
    require_admin if ChorusConfig.instance.restrict_data_source_creation?
  end
end
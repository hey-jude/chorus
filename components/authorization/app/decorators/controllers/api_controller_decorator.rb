ApiController.class_eval do
  rescue_from 'Authorization::AccessDenied', :with => :render_forbidden

  #PT Method to check if current user is in scope
  def current_user_in_scope?
    if Authorization::Permissioner.is_admin?(current_user)
      return false
    else
      Authorization::Permissioner.user_in_scope?(current_user)
    end
  end

  def current_user_is_admin?
    Authorization::Permissioner.is_admin?(current_user)
  end

  def require_data_source_create
    require_admin if ChorusConfig.instance.restrict_data_source_creation?
  end
end
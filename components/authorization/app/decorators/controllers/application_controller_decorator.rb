ApplicationController.class_eval do

  def require_admin
    head :forbidden unless logged_in? && (current_user.admin? || current_user.roles.include?(Role.find_by_name("Admin")))
  end
end
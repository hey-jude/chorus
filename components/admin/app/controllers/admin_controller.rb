class AdminController < ApplicationController
  layout 'admin/admin'
  helper Admin::Engine.helpers

  before_filter :require_login
  before_filter :admins_only

  def require_login
    if !logged_in? || current_session.expired?
      redirect_to "/"
    end
  end

  def admins_only
    if !current_user.try(:admin)
      redirect_to "/"
    end
  end
end
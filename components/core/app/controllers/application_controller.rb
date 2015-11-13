class ApplicationController < ActionController::Base

  attr_accessor :current_session
  protect_from_forgery

  before_filter :set_current_user
  after_filter :clear_current_user

  before_filter :require_login
  helper_method :current_user

  def current_user
    Thread.current[:user]
  end

  private

  def logged_in?
    !!current_user
  end

  def set_current_user
    # csrf protection mandates that we authenticate only with params[:session_id] if provided
    # csrf tokens are not required with session_id authentication, so this order is important
    session_id = params[:session_id] || session[:chorus_session_id]
    if session_id
      self.current_session = Session.find_by_session_id(session_id.to_s)
      Thread.current[:user] = current_session.try(:user)
    else
      Thread.current[:user] = nil
    end
  end

  def clear_current_user
    Thread.current[:user] = nil
  end

  def require_login
    head :unauthorized if !logged_in? || current_session.expired?
  end

  def require_admin
    head :forbidden unless logged_in? && (current_user.admin? || current_user.roles.include?(Role.find_by_name("Admin")))
  end

end
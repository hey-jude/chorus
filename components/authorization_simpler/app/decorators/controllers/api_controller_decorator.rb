ApiController.class_eval do
  # Triggers a 403 in the ApplicationController
  class AccessDenied < StandardError
    attr_reader :action, :subject, :payload

    def initialize(message, action, subject, payload=nil)
      @message = message
      @action = action
      @subject = subject
      @payload = payload
    end
  end

  def passes_role_based_authorization?(obj)
    return false unless obj

    all_actions_allowed_for_user = []
    current_user.roles.each do |role|
      all_actions_allowed_for_user + Authorization::ROLE_PERMISSIONS[role][obj.class.to_s]
    end
    all_actions_allowed_for_user.include? params[:action]
  end

  rescue_from 'AccessDenied', :with => :render_forbidden
  def raise_access_denied(sym, obj)
    raise AccessDenied.new("Not Authorized", sym, obj)
  end
end
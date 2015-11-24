#
# This class is the utility class that enforces access control.
# It consults the Roles, Groups, and Permissions tables to determine
# a user's abilities to view/modify objects in Chorus. It currently
# provides static methods and does not need to be instantiated.
#

module Authorization

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

  module Authority

    # Attempts to match the given activity with the activities
    # allowed by the user's roles.
    #
    # 'authorize' finds the permissions for each role the user has
    # on the given class. If a role permission matches the class
    # permission, then the user is authorized for that activity
    def self.authorize!(activity_symbol, object, user, options={})

      # retreive user and object information
      legacy_action_allowed = handle_legacy_action(options, object, user) if options
      chorus_class = ChorusClass.search_permission_tree(object.class, activity_symbol)
      # If we don't have new-style permissions chorus_classs for the object,
      # and the old permissions didn't pass either, then raise access denied
      raise_access_denied(activity_symbol, object) if !legacy_action_allowed && chorus_class.nil?

      if !legacy_action_allowed
        roles = retrieve_roles(user)

        chorus_object = ChorusObject.where(:instance_id => object.id, :chorus_class_id => chorus_class.id).first

        actual_class = chorus_class.name.constantize

        class_permissions = common_permissions_between(roles, chorus_class)

        if chorus_object
          role_ids = chorus_object.roles_for_user(user).map(&:id)
          object_permissions = Permission.where(:role_id => role_ids, :chorus_class_id => chorus_class.id)
        end

        permissions = [class_permissions, object_permissions].flatten.compact

        activity_mask = actual_class.bitmask_for(activity_symbol)

        allowed = permissions.any? do |permission|
          bit_enabled? permission.permissions_mask, activity_mask
        end
      end

      raise_access_denied(activity_symbol, object) if !allowed && !legacy_action_allowed

      allowed || legacy_action_allowed
    end

    private

    # This handles legacy authentication actions that are not role-based...
    # 'user' variable is usually passed current_user, but not always
    def self.handle_legacy_action(options, object, user)
      # or_actions are 'OR'd together
      or_actions = Array.wrap(options[:or])
      allowed = false

      or_actions.each do |action|
        allowed ||= case action
                      when :current_user_is_account_owner
                        account_owner(object, user) == user

                      when :current_user_is_object_recipient
                        object.recipient == user

                      when :current_user_is_objects_user
                        object.user == user

                      when :data_source_is_shared
                        if object.respond_to? :shared then
                          object.shared?
                        else
                          false
                        end

                      when :data_source_account_exists
                        # Collaborators don't have data_source permissions yet so we have to include this workaround until 5.7
                        user.data_source_accounts.exists?(:data_source_id => object.id) || object.is_a?(::HdfsDataSource)

                      when :current_user_can_create_comment_on_event
                        ::Events::Base.for_dashboard_of(user).find_by_id(object.id) || object.workspace.public?

                      when :current_user_is_author
                        object.author == user

                      when :current_user_can_see_comment
                        ::Events::Base.for_dashboard_of(user).find_by_id(object.event_id)

                      when :current_user_is_object_owner
                        object.owner == user

                      when :current_user_is_in_workspace
                        object.is_a?(::Workspace) && object.member?(user)

                      when :can_edit_sub_objects
                        handle_legacy_action({:or => :current_user_is_in_workspace}, object, user) &&
                          handle_legacy_action({:or => :workspace_is_not_archived}, object, user)

                      when :workspace_is_public
                        object.is_a?(::Workspace) && object.public?

                      when :workspace_is_not_archived
                        object.is_a?(::Workspace) && !object.archived?

                      when :current_user_is_referenced_user
                        object.is_a?(::User) && object == user

                      when :current_user_is_event_actor
                        (object.class < ::Events::Base) && user.id == object.actor.id

                      when :current_user_is_notes_workspace_owner
                        (object.class < ::Events::Base) && object.workspace && (object.workspace.owner == user)

                      when :current_user_is_worklets_workspace_owner
                        object.is_a?(Worklet) && object.workspace && object.workspace.owner == user

                      when :current_user_promoted_note
                        (object.class < ::Events::Base) && object.promoted_by == user

                      when :current_user_can_update_workspace
                        handle_legacy_workspace_update(user, object)

                      when :handle_legacy_show
                        handle_legacy_show(user, object)

                      else
                        false
                    end
      end
      allowed
    end

    # This method mimics the behavior of the
    # Allowy :show meta-programming that was a part of the old
    # permissions system when viewing events or notes. The old
    def self.handle_legacy_show(user, object)
      if object.is_a?(AlpineWorkfile) ||
        object.is_a?(Workfile) ||
        object.is_a?(ChorusWorkfile) ||
        object.is_a?(ChorusView) ||
        object.is_a?(Job) ||
        object.is_a?(LinkedTableauWorkfile)

        object.workspace.visible_to? user

      elsif object.is_a?(Comment)
        Events::Base.for_dashboard_of(current_user).exists?(comment.event_id)

      elsif object.is_a?(DataSource)
        object.accessible_to(user)

      elsif object.is_a?(Workspace)
        object.visible_to? user

      else
        true
      end
    end

    def self.handle_legacy_workspace_update(current_user, workspace)
      return false unless workspace.member?(current_user)
      if workspace.sandbox_id_changed? && workspace.sandbox_id
        return false unless workspace.owner == current_user
      end

      effective_owner_id = workspace.owner_id_changed? ? workspace.owner_id_was : workspace.owner_id
      effective_owner_id == current_user.id || (workspace.changed - ['name', 'summary']).empty?
    end

    # will be removed when ownership role is solidified
    def self.account_owner(data_source, current_user)
      account = data_source.account_for_user(current_user) || data_source.accounts.build(:owner => current_user)
      account.owner
    end

    def self.retrieve_roles(user)
      roles = user.roles.to_a

      # See comment on DEV-13359. Disabled for 5.7 release
      #user.groups.each do |group|
      #  roles.concat(group.roles) if group.roles.empty? == false
      #end

      roles
    end

    # returns the intersection of all permissions from roles and all permissions for the class
    def self.common_permissions_between(roles, chorus_class_or_object)
      all_roles_permissions = roles.inject([]) { |permissions, role| permissions.concat(role.permissions) }
      if chorus_class_or_object.nil? || chorus_class_or_object.permissions.empty? || all_roles_permissions.empty?
        return nil
      end
      common_permissions = all_roles_permissions & chorus_class_or_object.permissions
    end

    def self.bit_enabled?(bits, mask)
      (bits & mask) == mask
    end

    def self.raise_access_denied(sym, obj)
      raise AccessDenied.new("Not Authorized", sym, obj)
    end

  end
end
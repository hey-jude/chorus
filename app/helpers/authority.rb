#
# This class is the prototype utility class that enforces access control.
# It consults the Roles, Groups, and Permissions tables to determine
# a user's abilities to view/modify objects in Chorus. It currently
# provides static methods and does not need to be instantiated.
#

module Authority

  # Attempts to match the given activity with the activities
  # allowed by the user's roles. Raises an Allowy::AccessDenied
  # exception for backwards compatibility
  #
  # 'authorize' finds the permissions for each role the user has
  # on the given class. If a role permission matches the class
  # permission, then the user is authorized for that activity
  def self.authorize!(activity_symbol, object, user, options={})

    #return if legacy_action_allowed

    # retreive user and object information
    roles = retrieve_roles(user)
    chorus_class = ChorusClass.search_permission_tree(object.class)
    chorus_object = ChorusObject.find_by_chorus_class_id_and_instance_id(chorus_class.id, object.id)
    actual_class = object.class.name.constantize

    # check to see if object and user share scope. Ideally an object and user in different scopes shouldn't even
    # get to this check, because they cannot interact with an object they can't see


    # Is user owner of object?
    #return if is_owner?(user, object) || handle_legacy_action(options[:or], object, user)
    #return if chorus_object.owner == user

    # retreive and merge permissions
    # rename to permission_union, maybe
    class_permissions = common_permissions_between(roles, chorus_class)
    object_permissions = common_permissions_between(roles, chorus_object)
    permissions = [class_permissions, object_permissions].flatten.compact

    Chorus.log_debug("Could not find activity_symbol in #{actual_class.name} permissions") if actual_class::PERMISSIONS.index(activity_symbol).nil?

    # TODO: change bitmask to hash
    activity_mask = actual_class.bitmask_for(activity_symbol)

    # check to see if this user is allowed to do this action at the object or class level
    allowed = permissions.any? do |permission|
      bit_enabled? permission.permissions_mask, activity_mask
    end

    legacy_action_allowed = handle_legacy_action(options, object, user) if options

    raise_access_denied if !allowed && !legacy_action_allowed

    allowed || legacy_action_allowed
  end

  private

  # There are a bunch of ways of 'owning' an object so this
  # function needs to test each one
  def self.is_owner?(object, user)
    case object
    when is_a?(::Events::NoteOnWorkspace)

    end
  end

  # This handles legacy authentication actions that are not role-based...
  # 'current_user' is usually passed as current user, but not always
  def self.handle_legacy_action(options, object, user)
    # or_actions are 'OR'd together
    or_actions = Array.wrap(options[:or])
    allowed = false

    or_actions.each do |action|
      allowed ||= case action
                    when :current_user_is_workspace_owner
                      object.is_a?(::Workspace) && object.owner == user

                    when :current_user_is_in_workspace
                      object.is_a?(::Workspace) && object.member?(user)

                    when :can_edit_sub_objects
                      handle_legacy_action({ :or => :current_user_is_in_workspace }, object, user) &&
                      handle_legacy_action({ :or => :workspace_is_not_archived }, object, user)

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

                    when :current_user_promoted_note
                      (object.class < ::Events::Base) && object.promoted_by == user

                    when :current_user_can_update_workspace
                      WorkspaceAccess.new(user).update?(object)

                    # Intermediate legacy permissions are below this comment. These are dependent on permissiosns
                    # that haven't been implemented yet
                    when :current_user_can_view_note_target
                      # Note show uses old access permissions due to complicated permissions.
                      # We can change this to an authorize! call when the other objects are in the
                      # permissions system
                      ::Events::NoteAccess.new(user).show?(object)

                    else
                      false
                    end
    end
    allowed
  end

  # Most things use the owner association, but some (Notes, Events) use actor
  def self.is_owner?(user, object)
    if object.respond_to? :owner
      object.owner == user
    elsif object.respond_to? :actor
      object.actor == user
    else
      return false
    end
  end
  
  def self.retrieve_roles(user)
    roles = user.roles.clone
    user.groups.each do |group|
      roles << g.roles
    end
    roles
  end

  # returns the intersection of all permissions from roles and all permissions for the class
  def self.common_permissions_between(roles, chorus_class_or_object)
    all_roles_permissions = roles.inject([]){ |permissions, role| permissions.concat(role.permissions) }
    if chorus_class_or_object.nil? || chorus_class_or_object.permissions.empty? || all_roles_permissions.empty?
      return nil
    end
    common_permissions = all_roles_permissions & chorus_class_or_object.permissions
  end

  def self.bit_enabled?(bits, mask)
    (bits & mask) == mask
  end

  def self.raise_access_denied
    raise Allowy::AccessDenied.new("Unauthorized", nil, nil)
  end

end
Workspace.class_eval do
  include Authorization::Permissioner
  validates_with MemberCountValidator

  #PT. After creating the workspace object add entry to chorus_objects tables.
  #after_create  :add_to_permissions

  after_create :add_owner_to_workspace_roles
  def add_owner_to_workspace_roles
    self.add_user_to_object_role(owner, Role.find_by_name("Owner"))
    self.add_user_to_object_role(owner, Role.find_by_name("ProjectManager"))
  end

  def self.add_search_permissions(current_user, search)
    unless current_user.admin?
      search.build do
        any_of do
          without :security_type_name, Workspace.security_type_name
          with :member_ids, current_user.id
          with :public, true
        end
      end
    end
  end

  def self.workspaces_for(user)
    if user.admin?
      all
    else
      accessible_to(user)
    end
  end

  def self.accessible_to(user)
    with_membership = user.memberships.pluck(:workspace_id)

    workspaces = where('workspaces.public OR
          workspaces.id IN (:with_membership) OR
          workspaces.owner_id = :user_id',
          :with_membership => with_membership,
          :user_id => user.id
         )

    # PT. 7/9. filter_by_scope returns an array of workspaces instead of ActiveRelation which causes a problem in the caller class (WorkspaceController)
    # Filter by scope
    #  if Authorization::Permissioner.user_in_scope?(user)
    #    filter_by_scope(user, workspaces)
    #  else
    #    workspaces
    #  end
  end

  def members_accessible_to(user)
    if public? || members.include?(user)
      members
    else
      []
    end
  end

  def permissions_for(user)
    has_membership = user.memberships.find_by_workspace_id(id)
    perm = if user.admin? || (owner_id == user.id)
      [:admin]
    elsif has_membership
      [:read, :commenting, :update, :duplicate_chorus_view]
    elsif public?
      [:read, :commenting]
    else
      []
    end
    perm << :create_workflow if (user.user_type == License::USERS_ANALYTICS_DEVELOPER || user.user_type == License::USERS_DATA_ANALYST) && has_membership

    perm
  end

  def visible_to?(user)
    public? || member?(user)
  end
end

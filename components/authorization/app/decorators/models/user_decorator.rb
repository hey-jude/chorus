User.class_eval do
  include Permissioner

  # roles, groups, and permissions
  has_and_belongs_to_many :groups, -> { uniq }
  has_and_belongs_to_many :roles, -> { uniq }, :after_add => :add_missing_admin_role, :after_remove => :remove_extra_admin_role
  #belongs_to :chorus_scope

  # object_roles allow a User to have different roles for different objects (currently just Workspace)
  has_many :chorus_object_roles
  has_many :object_roles, :through => :chorus_object_roles, :source => :role

  # Delete HABTM association objects
  before_destroy { |user| user.groups.destroy_all }
  before_destroy { |user| user.roles.destroy_all }

  validates_with UserCountValidator, :on => :create
  validates_with DeveloperCountValidator, AdminCountValidator

  after_initialize :defaults

  def defaults
    collaborator_role = Role.find_or_create_by(:name => "Collaborator")
    user_role = Role.find_or_create_by(:name => "User")
    self.roles << collaborator_role unless self.roles.include? collaborator_role
    self.roles << user_role unless self.roles.include? user_role
  end

  def add_missing_admin_role(role)
    admin_roles = [Role.find_by_name("Admin"), Role.find_by_name("ApplicationManager")]
    self.admin = true if admin_roles.include? role
  end

  def remove_extra_admin_role(role)
    admin_roles = [Role.find_by_name("Admin"), Role.find_by_name("ApplicationManager")]
    self.admin = false if admin_roles.include? role
  end

  def self.admin_count
    admin.size
  end

  def admin=(value)
    admin_role = Role.find_by_name("Admin")
    app_manager_role = Role.find_by_name("ApplicationManager")
    site_admin_role = Role.find_by_name("SiteAdministrator")

    if ActiveRecord::ConnectionAdapters::Column.value_to_boolean(value)

      admin_role.users << self unless admin_role.users.include? self
      app_manager_role.users << self unless app_manager_role.users.include? self
      if self.username == 'chorusadmin'
        site_admin_role.users << self unless site_admin_role.users.include? self
      end
      write_attribute(:admin, value)

    else
      unless self.class.admin_count == 1 # don't unset last admin

        admin_role.users.delete(self) if admin_role.users.include? self
        app_manager_role.users.delete(self) if app_manager_role.users.include? self
        site_admin_role.users.delete(self) if site_admin_role.users.include? self
        write_attribute(:admin, value)

      end
    end

  end

  def developer=(value)
    write_attribute(:developer, value)
    dev_role = Role.find_by_name("WorkflowDeveloper")
    if value == true || value == "true"
      dev_role.users << self unless dev_role.users.include? self
    else
      dev_role.users.delete(self) if dev_role.users.include? self
    end
  end

  def self.developer_count
    developer.size
  end
end

require 'digest'

class User < ActiveRecord::Base
  include SoftDelete
  include TaggableBehavior
  include Permissioner

  VALID_SORT_ORDERS = HashWithIndifferentAccess.new(
    :first_name => "LOWER(users.first_name)",
    :last_name => "LOWER(users.last_name)"
  )

  DEFAULT_SORT_ORDER = VALID_SORT_ORDERS[:first_name]

  attr_accessible :username, :password, :first_name, :last_name, :email, :title, :dept, :notes, :subscribed_to_emails, :auth_method, :ldap_group_id
  attr_accessor :password

  has_many :gpdb_data_sources, :foreign_key => :owner_id
  has_many :oracle_data_sources, :foreign_key => :owner_id
  has_many :jdbc_data_sources, :foreign_key => :owner_id
  has_many :pg_data_sources, :foreign_key => :owner_id
  has_many :hdfs_data_sources, :foreign_key => :owner_id
  has_many :gnip_data_sources, :foreign_key => :owner_id
  has_many :data_source_accounts, :foreign_key => :owner_id, :dependent => :destroy
  has_many :dashboard_items, :dependent => :destroy

  #PT. There is belongs_to relationship on open_workflow_events model.
  has_many :open_workfile_events

  has_many :owned_workspaces, :foreign_key => :owner_id, :class_name => 'Workspace'
  has_many :memberships, :dependent => :destroy
  has_many :workspaces, :through => :memberships
  has_many :owned_jobs, :foreign_key => :owner_id, :class_name => 'Job'

  has_many :activities, :as => :entity
  has_many :events, :through => :activities
  has_many :notifications, :foreign_key => 'recipient_id'

  has_many :comments

  # roles, groups, and permissions
  has_and_belongs_to_many :groups, -> { uniq }
  has_and_belongs_to_many :roles, -> { uniq }, :after_add => :add_missing_admin_role, :after_remove => :remove_extra_admin_role
  #belongs_to :chorus_scope

  # object_roles allow a User to have different roles for different objects (currently just Workspace)
  has_many :chorus_object_roles
  has_many :object_roles, :through => :chorus_object_roles, :source => :role


  has_attached_file :image, :path => ":rails_root/system/:class/:id/:style/:basename.:extension",
                    :url => "/:class/:id/image?style=:style",
                    :default_url => '/images/general/default-user.png', :styles => {:icon => "50x50>"}
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  validates_presence_of :username, :first_name, :last_name, :email
  validates_uniqueness_of :username, :case_sensitive => false, :allow_blank => true, :scope => :deleted_at
  validates_format_of :email, :with => /[\w\.-]+(\+[\w-]*)?@([\w-]+\.)+[\w-]+/
  validates_format_of :username, :with => /\A\S+\z/, :unless => lambda { LdapClient.enabled? }
  validates_presence_of :password, :unless => lambda { password_digest? || LdapClient.enabled? || legacy_password_digest? }
  validates_length_of :password, :minimum => 6, :maximum => 256, :if => :password
  validates_length_of :username, :first_name, :last_name, :email, :title, :dept, :maximum => 256
  validates_length_of :notes, :maximum => 4096
  validates_attachment_size :image, :less_than => ChorusConfig.instance['file_sizes_mb']['user_icon'].megabytes, :message => :file_size_exceeded
  validate :confirm_ldap_user, :if => lambda { LdapClient.enabled? }, :on => :create

  validates_with UserCountValidator, :on => :create
  validates_with DeveloperCountValidator, AdminCountValidator

  attr_accessor :highlighted_attributes, :search_result_notes

  if ENV['SKIP_SOLR'] != 'true'
    searchable_model do
      text :first_name, :stored => true, :boost => SOLR_PRIMARY_FIELD_BOOST
      text :last_name, :stored => true, :boost => SOLR_PRIMARY_FIELD_BOOST
      text :username, :stored => true, :boost => SOLR_SECONDARY_FIELD_BOOST
      text :email, :stored => true, :boost => SOLR_SECONDARY_FIELD_BOOST
    end
  end

  before_save :update_password_digest, :unless => lambda { password.blank? }
  # Delete HABTM association objects
  before_destroy { |user| user.groups.destroy_all }
  before_destroy { |user| user.roles.destroy_all }

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

  def accessible_events(current_user)
    events.where("workspace_id IS NULL
                    OR workspace_id IN
                      (SELECT id FROM workspaces
                        WHERE public IS TRUE)
                    OR workspace_id IN
                      (SELECT workspace_id FROM memberships
                        WHERE user_id = #{current_user.id})").includes(:actor, :target1, :target2)
  end

  def self.order(field)
    sort_by = VALID_SORT_ORDERS[field] || DEFAULT_SORT_ORDER
    super(sort_by, :id)
  end

  def self.authenticate(username, password)
    named(username).try(:authenticate, password)
  end

  def self.named(username)
    where("lower(users.username) = ?", username.downcase).first
  end

  def self.admin_count
    admin.size
  end

  def admin?
    self.admin
  end

  scope :admin, -> { where(:admin => true) }

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

  scope :developer, -> { where(:developer => true) }

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

  def authenticate(unencrypted_password)
    migrate_password_digest(unencrypted_password) if legacy_password_digest?
    authenticate_password_digest(unencrypted_password) && self
  end

  def destroy

    if owned_workspaces.count > 0
      errors.add(:workspace_count, :equal_to, {:count => owned_workspaces.count})
      raise ActiveRecord::RecordInvalid.new(self)
    elsif gpdb_data_sources.count > 0
      errors.add(:user, :nonempty_data_source_list)
      raise ActiveRecord::RecordInvalid.new(self)
    end

    owned_jobs.each(&:reset_ownership!)

    super
  end

  def accessible_account_ids
    shared_account_ids = DataSourceAccount.joins(:data_source).where("data_sources.shared = true").collect(&:id)
    (shared_account_ids + data_source_account_ids).uniq
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def update_password_digest
    self.password_salt = SecureRandom.hex(20)
    self.password_digest = digest_password(password)
  end

  def digest_password(unencrypted_password)
    Digest::SHA256.hexdigest(unencrypted_password + password_salt)
  end

  def authenticate_password_digest(unencrypted_password)
    digest_password(unencrypted_password) == password_digest.to_s
  end

  def authenticate_legacy_password_digest(unencrypted_password)
    Digest::SHA1.hexdigest(unencrypted_password) == legacy_password_digest.to_s
  end

  def migrate_password_digest(unencrypted_password)
    return unless authenticate_legacy_password_digest(unencrypted_password)
    self.password = unencrypted_password
    self.legacy_password_digest = nil
    save!
  end

  def confirm_ldap_user
    results = LdapClient.search(username)
    if results.empty?
      raise LdapClient::LdapCouldNotBindWithUser.new(
              "No entry found for user #{username} in LDAP directory server. Please contact your
system administrator"
            )
    end
  end
end
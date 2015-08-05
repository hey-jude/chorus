require 'digest'
require 'soft_delete'

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
  has_and_belongs_to_many :groups, :uniq => true
  has_and_belongs_to_many :roles, after_add: :check_admin_role, after_remove: :uncheck_admin_role, :uniq => true
  #belongs_to :chorus_scope

  def uncheck_admin_role(role)
    Chorus.log_debug("-----------  #{role.name} is removed for #{self.username} --------")
    site_admin = Role.find_by_name('SiteAdministrator')
    admin = Role.find_by_name('Admin')
    if role.name == 'ApplicationAdministrator'
      if self.roles.include?(admin)
        self.admin = true
      else
        Chorus.log_debug("---- Removing admin role to #{self.username} ---")
        self.admin = false
      end
      self.save!
    end
    if role.name = 'Admin'
      if self.roles.include?(site_admin)
        self.admin = true
      else
        Chorus.log_debug("---- Removing admin role to #{self.username} ---")
        self.admin = false
      end
      self.save!
    end
    #if self.admin == true && (self.roles.include?(site_admin) || self.roles.include?(admin)) == false
    #  self.admin = false
    #  self.save!
    #end
  end

  def check_admin_role(role)
    Chorus.log_debug("-----------  #{role.name} is added for #{self.username} --------")
    admin = Role.find_by_name('Admin')
    site_admin = Role.find_by_name('SiteAdministrator')
    if self.admin == false && self.roles.include?(site_admin)
      Chorus.log_debug("---- Assigning admin role to #{self.username} ---")
      self.admin = true
      self.save!
    end
    if self.admin == false && self.roles.include?(admin)
      Chorus.log_debug("---- Assigning admin role to #{self.username} ---")
      self.admin = true
      self.save!
    end

    #if self.admin == true && (self.roles.include?(site_admin) || self.roles.include?(admin)) == false
    #  self.admin = false
    #  self.save!
    #end
  end

  # object_roles allow a User to have different roles for different objects (currently just Workspace)
  has_many :chorus_object_roles
  has_many :object_roles, :through => :chorus_object_roles, :source => :role


  has_attached_file :image, :path => ":rails_root/system/:class/:id/:style/:basename.:extension",
                    :url => "/:class/:id/image?style=:style",
                    :default_url => '/images/general/default-user.png', :styles => {:icon => "50x50>"}

  validates_presence_of :username, :first_name, :last_name, :email
  validates_uniqueness_of :username, :case_sensitive => false, :allow_blank => true, :scope => :deleted_at
  validates_format_of :email, :with => /[\w\.-]+(\+[\w-]*)?@([\w-]+\.)+[\w-]+/
  validates_format_of :username, :with => /^\S+$/, :unless => lambda { LdapClient.enabled? }
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
    collaborator_role = Role.find_or_create_by_name("Collaborator")
    self.roles << collaborator_role unless self.roles.include? collaborator_role
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
    admin_role = Role.find_by_name("ApplicationManager")
    if admin_role != nil
      Role.find_by_name("ApplicationManager").users.size
    else
      return 0
    end
  end

  def admin?
      self.admin || Permissioner.is_admin?(self)
  end

  scope :admin, where(:admin => true)

  def admin=(value)
    unless admin? && self.class.admin_count == 1 # don't unset last admin
      write_attribute(:admin, value)

      admin_role = Role.find_by_name("Admin")
      site_admin_role = Role.find_by_name("ApplicationManager")
      if admin_role && value == true
        admin_role.users << self
        site_admin_role.users << self
      elsif admin_role
        admin_role.users.delete(self)
        site_admin_role.users.delete(self)
      else
          #
      end
    end
  end

  scope :developer, where(:developer => true)

  def developer=(value)
    write_attribute(:developer, value)
    dev_role = Role.find_by_name("WorkflowDeveloper")
    if value
      dev_role.users << self
    else
      dev_role.users.delete(self)
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
      errors.add(:workspace_count, :equal_to, {:count => 0})
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

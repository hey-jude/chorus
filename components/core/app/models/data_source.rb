class DataSource < ActiveRecord::Base
  include SoftDelete
  include TaggableBehavior
  include Notable
  include CommonDataSourceBehavior
  include Permissioner

  # DO NOT CHANGE the order of these permissions, you'll accidently change everyone's permissons across the site.
  # Order: edit, show_contents

  attr_accessor :db_username, :db_password
  attr_accessible :name, :description, :host, :port, :state, :ssl, :db_name, :db_username, :db_password, :is_hawq, :as => [:default, :create]
  attr_accessible :shared, :as => :create

  # Must happen before accounts are destroyed
  before_destroy :cancel_imports

  belongs_to :owner, :class_name => 'User'
  has_many :accounts, :class_name => 'DataSourceAccount', :inverse_of => :data_source, :foreign_key => 'data_source_id', :dependent => :destroy
  has_one :owner_account, ->(record) { where :owner_id => record.owner_id }, :class_name => 'DataSourceAccount', :foreign_key => 'data_source_id', :inverse_of => :data_source

  has_many :activities, :as => :entity
  has_many :events, :through => :activities
  has_many :databases

  before_save :update_data_source_account_for_owner, :if => :should_update_account?

  validates_associated :owner_account, :if => :validate_owner?
  validates_presence_of :name, :host
  validates_length_of :name, :maximum => 64
  validates_with DataSourceNameValidator

  after_update :solr_reindex_later, :if => :shared_changed?

  after_update :create_name_changed_event, :if => :current_user

  after_create :enqueue_refresh
  after_create :create_created_event, :if => :current_user

  after_destroy :create_deleted_event, :if => :current_user

  def check_connection_status
    QC.enqueue_if_not_queued('DataSource.check_status', self.id)
  end

  def self.by_type(entity_types)
    if entity_types.present?
      where(type: [*entity_types].map(&:classify))
    else
      self
    end
  end

  def self.owned_by(user)
    if user.admin?
      all
    else
      where(:owner_id => user.id)
    end
  end

  def self.reindex_data_source(id)
    data_source = find(id)
    data_source.solr_index
    data_source.datasets(:reload => true).each(&:solr_index)
  end

  def self.unshared
    where("data_sources.shared = false OR data_sources.shared IS NULL")
  end

  def self.accessible_to(user)
    where('data_sources.shared OR data_sources.owner_id = :owned OR data_sources.id IN (:with_membership)',
          owned: user.id,
          with_membership: user.data_source_accounts.pluck(:data_source_id)
    )
  end

  def accessible_to(user)
    DataSource.accessible_to(user).include?(self)
  end

  def self.refresh_databases(data_source_id)
    find(data_source_id).refresh_databases
  end

  def self.create_for_entity_type(entity_type, user, data_source_hash)
    entity_class = entity_type.classify.constantize rescue NameError
    raise ApiValidationError.new(:entity_type, :invalid) unless entity_class < DataSource
    entity_class.create_for_user(user, data_source_hash)
  end

  def valid_db_credentials?(account)
    success = true
    connection = connect_with(account).connect!
  rescue DataSourceConnection::InvalidCredentials
    success = false
  ensure
    connection.try(:disconnect)
    success
  end

  def is_hawq_data_source?(account)
    connection = connect_with(account)
    connection.is_hawq? if is_hawq
  end

  def connect_with(account, options = {})
    connection = connection_class.new(self, account, options.reverse_merge({:logger => Rails.logger}))

    if block_given?
      connection.with_connection do
        yield connection
      end
    else
      connection
    end
  end

  def connect_as_owner
    connect_with(owner_account)
  end

  def connect_as(user)
    connect_with(account_for_user!(user))
  end

  def account_for_user(user)
    if shared?
      owner_account
    else
      account_owned_by(user)
    end
  end

  def account_for_user!(user)
    #account_for_user(user) || (raise ActiveRecord::RecordNotFound)
    # Fix for DEV-12064. Error message not appearing when attempting to view a non-shared DB data source after upgrade.
    # Always throw AccessDenied exception to force UI to pop-up credential dialog box.
    account_for_user(user) || (raise Authority::AccessDenied.new("Unuthorized", :show, self))
  end

  def data_source
    self
  end

  def self.check_status(id)
    data_source = DataSource.find(id)
    data_source.check_status! unless data_source.disabled?
  rescue => e
    Rails.logger.error "Unable to check status of DataSource: #{data_source.inspect}"
    Rails.logger.error "#{e.message} :  #{e.backtrace}"
  end

  def self.refresh(id, options={})
    symbolized_options = options.symbolize_keys
    symbolized_options[:new] = symbolized_options[:new].to_s == "true" if symbolized_options[:new]
    find(id).refresh symbolized_options
  end

  def refresh(options={})
    return if disabled?
    options[:skip_dataset_solr_index] = true if options[:new]
    refresh_databases options

    if options[:skip_dataset_solr_index]
      #The first refresh_all did not index the datasets in solr due to performance.
      refresh_schemas options.merge(:force_index => true)
    end
  end

  def refresh_databases_later
    SolrIndexer.SolrQC.enqueue_if_not_queued('DataSource.refresh_databases', id) unless being_destroyed? || disabled?
  end

  def solr_reindex_later
    SolrIndexer.SolrQC.enqueue_if_not_queued('DataSource.reindex_data_source', id) unless disabled?
  end

  def update_state_and_version
    self.state = "online"
    self.version = connect_as_owner.version
  rescue => e
    Chorus.log_error "Could not connect while updating state: #{e}: #{e.message} on #{e.backtrace[0]}"
    self.state = "offline"
  end

  def attempt_connection(user)
    # pass empty block to attempt connection and ensure connection disconnects
    # so we do not leak connections
    connect_as(user).with_connection {}
  end

  def save_if_incomplete!(params)
    if params["state"] == "incomplete"
      save!(:validate => false)
    else
      save!
    end
    self
  end

  private

  def build_data_source_account_for_owner
    build_owner_account(:owner => owner, :db_username => db_username, :db_password => db_password)
    # DataSourceAccount.new(:owner => owner, :db_username => db_username, :db_password => db_password)
  end

  def should_update_account?
    if owner_account.nil?
      build_data_source_account_for_owner
    end
    (!db_password.nil? && db_password != owner_account.db_password)|| (db_username && db_username != owner_account.db_username)
  end

  def update_data_source_account_for_owner
    owner_account.assign_attributes(:db_username => db_username, :db_password => db_password)
    if incomplete?
      owner_account.save!(validate: false)
    else
      owner_account.save!
    end
  end

  def validate_owner?
    (self.changed.include?('host')        ||
      self.changed.include?('port')         ||
      self.changed.include?('db_name'))     &&
      should_update_account? == false
  end

  def enqueue_refresh
    SolrIndexer.SolrQC.enqueue_if_not_queued("DataSource.refresh", self.id, 'new' => true) unless disabled?
  end

  def enqueue_check_status!
    QC.enqueue_if_not_queued('DataSource.check_status', self.id)
  end

  def account_owned_by(user)
    accounts.find_by_owner_id(user.id)
  end

  def create_created_event
    Events::DataSourceCreated.by(current_user).add(:data_source => self)
  end

  def create_name_changed_event
    if name_changed?
      Events::DataSourceChangedName.by(current_user).add(
        :data_source => self,
        :old_name => name_was,
        :new_name => name
      )
    end
  end

  def create_deleted_event
    Events::DataSourceDeleted.by(current_user).add(:data_source => self)
  end
end
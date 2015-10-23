module CommonDataSourceBehavior
  extend ActiveSupport::Concern

  included do
    before_update :create_state_change_event, :if => :current_user
    before_update :enqueue_check_status!, :if => :should_check_status?
    validates :state, :inclusion => %w(online offline incomplete disabled enabled)

    def should_check_status?
      changed.include?("state") && state == "enabled"
    end

    attr_accessor :highlighted_attributes, :search_result_notes
    searchable_model do
      text :name, :stored => true, :boost => SOLR_PRIMARY_FIELD_BOOST
      text :description, :stored => true, :boost => SOLR_SECONDARY_FIELD_BOOST
    end

    def self.type_name
      'DataSource'
    end

    validates_with DataSourceTypeValidator
  end

  def check_status!
    update_state_and_version

    touch(:last_checked_at)
    touch(:last_online_at) if online?
    save!
  end

  def license_type
    type
  end

  def disabled?
    state == 'disabled' || state == 'incomplete'
  end

  def incomplete?
    state == 'incomplete'
  end

  def online?
    state == 'online'
  end

  def attempt_connection(user)
  end

  def create_state_change_event
    if state_changed? && ( state == "disabled" || state == "enabled" )
      attributes = {
          :data_source => self,
          :old_state => state_was,
          :new_state => state
      }

      Events::DataSourceChangedState.by(current_user).add(attributes)
    end
  end
end

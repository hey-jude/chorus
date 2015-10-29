class OpenWorkfileEvent < ActiveRecord::Base
  belongs_to :user
  belongs_to :workfile
  include Permissioner

  attr_accessible :user, :workfile
  validates_presence_of :user, :workfile

  after_create :delete_old_events_for_user

  EVENT_LIMIT = 15

  # KT TODO: freshly added in 5.7 and, causes a bug --  see DEV-13352
  def delete_old_events_for_user
    number_of_events = OpenWorkfileEvent.where(:user_id => self.user_id).count

    if number_of_events > EVENT_LIMIT
      oldest_event_id = OpenWorkfileEvent.where('user_id = ?', user_id).order('created_at DESC').limit(EVENT_LIMIT).last.id
      old_events = OpenWorkfileEvent.where("id < ? AND user_id = ?", oldest_event_id, self.user_id)
      old_events.destroy_all
    end
  end
end
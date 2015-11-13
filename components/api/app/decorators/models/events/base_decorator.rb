Events::Base.class_eval do

  # PT 1/15/15 This will auto-refresh the JSON data object for workspace
  #after_save :refresh_cache
  after_save :delete_cache

  # Upon creating or updating an event, refresh the JSON object in cache.
  def delete_cache
    if self.id != nil && current_user != nil
      cache_key = "activities/Users/#{current_user.id}/#{self.class.name}/#{self.id}-#{(self.updated_at.to_f * 1000).round(0)}"
      Chorus.log_debug "-- BEFORE SAVE: Clearing cache for #{self.class.name} with ID = #{self.id} --"
      Rails.cache.delete(cache_key)
      return true # Prevent a missing key from the callback chain
    end
  end

  def self.presenter_class
    Api::EventPresenter
  end
end
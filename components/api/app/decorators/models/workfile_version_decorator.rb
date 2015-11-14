WorkfileVersion.class_eval do

  # Fix for DEV-8648. Creating a SQL workfile takes a long time. We are not caching workfileVersion objects so there is no need for deleting cache.
  before_save :delete_cache

  def delete_cache
    if self.id != nil && current_user != nil
      cache_key = "workspace:workfiles/Users/#{current_user.id}/#{self.class.name}/#{self.id}-#{(self.updated_at.to_f * 1000).round(0)}"
      Chorus.log_debug "-- BEFORE SAVE: Clearing cache for #{self.class.name} with cache key = #{cache_key} --"
      Rails.cache.delete(cache_key)
    end
    return true
  end

end
Workspace.class_eval do

  # PT 12/19/14 This will auto-refresh the JSON data object for workspace
  after_save :delete_cache

  def delete_cache(user = nil)

    if self.id != nil && user != nil
      cache_key = "home:workspaces/Users/#{user.id}/#{self.class.name}/#{self.id}-#{(self.updated_at.to_f * 1000).round(0)}"
      Chorus.log_debug "-- BEFORE SAVE: Clearing cache for #{self.class.name} with cache key = #{cache_key} --"
      Rails.cache.delete(cache_key)
      cache_key = "workspaces:workspaces/Users/#{user.id}/#{self.class.name}/#{self.id}-#{(self.updated_at.to_f * 1000).round(0)}"
      Rails.cache.delete(cache_key)
      return true
    elsif self.id != nil && current_user != nil
      #Fix for 87339340. Avoid searching for cache if the record is newly created and does have an ID before saving to database.
      cache_key = "home:workspaces/Users/#{current_user.id}/#{self.class.name}/#{self.id}-#{(self.updated_at.to_f * 1000).round(0)}"
      Chorus.log_debug "-- BEFORE SAVE: Clearing cache for #{self.class.name} with cache key = #{cache_key} --"
      Rails.cache.delete(cache_key)
      cache_key = "workspaces:workspaces/Users/#{current_user.id}/#{self.class.name}/#{self.id}-#{(self.updated_at.to_f * 1000).round(0)}"
      Rails.cache.delete(cache_key)
      return true
    end
  end

end
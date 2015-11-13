Dataset.class_eval do

  after_save :delete_cache

  def refresh_cache
    Chorus.log_debug "-- Refreshing cache for #{self.class.name} with ID = #{self.id} --"
    options = {:workspace => self.workspace, :cached => true, :namespace => "workspace:datasets"}
    dataset = Dataset.includes(Dataset.eager_load_associations).where("id = ?", self.id)
    ApiPresenter.present(dataset, nil, options)
  end

  def delete_cache
    #Fix for 87339340. Avoid searching for cache if the record is newly created and does have an ID before saving to database.
    if self.id != nil && current_user != nil
      cache_key = "workspace:datasets/Users/#{current_user.id}/#{self.class.name}/#{self.id}-#{(self.updated_at.to_f * 1000).round(0)}"
      Chorus.log_debug "-- BEFORE SAVE: Clearing cache for #{self.class.name} with cache key = #{cache_key} --"
      Rails.cache.delete(cache_key)
      #Rails.cache.delete_matched(/.*\/#{self.class.name}\/#{self.id}-#{(self.updated_at.to_f * 1000).round(0)}/)
    end
    return true
  end

end
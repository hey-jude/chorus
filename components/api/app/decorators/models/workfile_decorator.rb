Workfile.class_eval do

  before_save :delete_cache

  def refresh_cache
    Chorus.log_debug "-- Refreshing cache for #{self.class.name} with ID = #{self.id} --"
    options = {:workfile_as_latest_version => true, :list_view => true, :cached => true, :namespace => "workspace:workfiles"}
    workfile = Workfile.includes(Workfile.eager_load_associations).where("id = ?", self.id)
    ApiPresenter.present(workfile, nil, options)
  end

  def delete_cache
    #Fix for 87339340. Avoid searching for cache if the record is newly created and does have an ID before saving to database.
    if self.id != nil && current_user != nil
      cache_key = "workspace:workfiles/Users/#{current_user.id}/#{self.class.name}/#{self.id}-#{(self.updated_at.to_f * 1000).round(0)}"
      Chorus.log_debug "-- BEFORE SAVE: Clearing cache for #{self.class.name} with cache key = #{cache_key} --"
      Rails.cache.delete(cache_key)
      # Fix for DEV-8648. Creating a SQL workfile takes a long time. We are not caching workfileVersion objects so there is no need for deleting cache.
      # Fix for DEV-8954 When I rename a myfilename.pmml to myfiletest.pmml, the changes does not take place on the front end
      if self.latest_workfile_version != nil
        Chorus.log_debug "-- BEFORE SAVE: Clearing cache for WorkfileVersion with ID = #{self.latest_workfile_version.id} --"
        self.latest_workfile_version.delete_cache
      end
    end
    return true
  end

end
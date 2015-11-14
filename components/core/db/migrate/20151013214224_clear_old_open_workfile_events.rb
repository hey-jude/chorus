class ClearOldOpenWorkfileEvents < ActiveRecord::Migration
  def delete_workfile_events_for_user(user_id)
    event_limit = 15
    if OpenWorkfileEvent.where(:user_id => user_id).count > event_limit
      oldest_event_id = OpenWorkfileEvent.where(:user_id => user_id)
                                         .order('created_at DESC')
                                         .limit(event_limit)
                                         .last.id

      # Clean up permissioner objects
      chorus_class_id = ChorusClass.find_by(:name => 'OpenWorkfileEvent').id
      chorus_obj_delete_sql = %Q(
      delete from chorus_objects where chorus_objects.id in \(
        select chorus_objects.id from chorus_objects
        inner join open_workfile_events on chorus_objects.instance_id = open_workfile_events.id
        where
          chorus_objects.chorus_class_id = #{chorus_class_id}
          and open_workfile_events.user_id = #{user_id}
          and open_workfile_events.id < #{oldest_event_id}
      \))
      execute chorus_obj_delete_sql

      # Clean up workfile_events
      open_workfile_events_delete_sql = "delete from #{OpenWorkfileEvent.table_name} where user_id = #{user_id} and id < #{oldest_event_id}"
      execute open_workfile_events_delete_sql
    end
  end

  def change
    # For each unique user id, clean up the open workfile events
    OpenWorkfileEvent.uniq.pluck(:user_id).each do |user_id|
      # Silencing exceptions because this code also happens at runtime and we don't want to hang up installations/upgrades
      begin
        delete_workfile_events_for_user(user_id)
      rescue Exception => e
        puts e.message
        puts e.backtrace.inspect
      end
    end
  end
end



admin_role = Role.find_or_create_by_name(:name => 'admin'.camelize)
owner_role = Role.find_or_create_by_name(:name => 'owner'.camelize)
user_role = Role.find_or_create_by_name(:name => 'user'.camelize)
developer_role = Role.find_or_create_by_name(:name => 'developer'.camelize)
collaborator_role = Role.find_or_create_by_name(:name => 'collaborator'.camelize)
site_admin_role = Role.find_or_create_by_name(:name => 'site_administrator'.camelize)
app_admin_role = Role.find_or_create_by_name(:name => 'application_administrator'.camelize)
app_manager_role = Role.find_or_create_by_name(:name => 'application_manager'.camelize)
workflow_developer_role = Role.find_or_create_by_name(:name => 'workflow_developer'.camelize)
project_manager_role = Role.find_or_create_by_name(:name => 'project_manager'.camelize)
project_developer_role = Role.find_or_create_by_name(:name => 'project_developer'.camelize)
contributor_role = Role.find_or_create_by_name(:name => 'contributor'.camelize)
data_scientist_role = Role.find_or_create_by_name(:name => 'data_scientist'.camelize)

role_class = ChorusClass.where(:name => 'role'.camelize).first
chorus_scope_class = ChorusClass.where(:name => 'chorus_scope'.camelize).first
workspace_class = ChorusClass.where(:name => 'workspace'.camelize).first
user_class = ChorusClass.where(:name => 'user'.camelize).first
account_class = ChorusClass.where(:name => 'account'.camelize).first
datasource_class = ChorusClass.where(:name => 'data_source'.camelize).first
group_class = ChorusClass.where(:name => 'group'.camelize).first
database_class = ChorusClass.where(:name => 'database'.camelize).first
job_class  = ChorusClass.where(:name => 'job'.camelize).first
gpdb_view_class = ChorusClass.where(:name => 'gpdb_view'.camelize).first
gpdb_table_class = ChorusClass.where(:name => 'gpdb_table'.camelize).first
gpdb_dataset_class = ChorusClass.where(:name => 'gpdb_dataset'.camelize).first
gpdb_schema_class = ChorusClass.where(:name => 'gpdb_schema'.camelize).first

hdfs_entry_class = ChorusClass.where(:name => 'hdfs_entry'.camelize).first
hdfs_data_source_class = ChorusClass.where(:name => 'hdfs_data_source'.camelize).first

milestone_class = ChorusClass.where(:name => 'milestone'.camelize).first
membership_class = ChorusClass.where(:name => 'membership'.camelize).first
workfile_class = ChorusClass.where(:name => 'workfile'.camelize).first
workflow_class = ChorusClass.where(:name => 'workflow'.camelize).first
activity_class = ChorusClass.where(:name => 'activity'.camelize).first
event_class = ChorusClass.where(:name => 'events::Base'.camelize).first
note_class = ChorusClass.where(:name => 'note'.camelize).first
comment_class = ChorusClass.where(:name => 'comment'.camelize).first
chorus_view_class = ChorusClass.where(:name => 'chorus_view'.camelize).first
sandbox_class = ChorusClass.where(:name => 'sandbox'.camelize).first
csv_file_class = ChorusClass.where(:name => 'csv_file'.camelize).first
dataset_class = ChorusClass.where(:name => 'dataset'.camelize).first
associated_dataset_class = ChorusClass.where(:name => 'associated_dataset'.camelize).first
import_class = ChorusClass.where(:name => 'import'.camelize).first
pg_table_class = ChorusClass.where(:name => 'pg_table'.camelize).first
pg_view_class = ChorusClass.where(:name => 'pg_view'.camelize).first
pg_schema_class = ChorusClass.where(:name => 'pg_schema'.camelize).first
hdfs_dataset_class = ChorusClass.where(:name => 'hdfs_dataset'.camelize).first
jdbc_dataset_class = ChorusClass.where(:name => 'jdbc_dataset'.camelize).first


tag_class = ChorusClass.where(:name => 'tag'.camelize).first
schema_class = ChorusClass.where(:name => 'schema'.camelize).first
task_class = ChorusClass.where(:name => 'task'.camelize).first
insight_class = ChorusClass.where(:name => 'insight'.camelize).first
upload_class = ChorusClass.where(:name => 'upload'.camelize).first


# Check if we need to run these migrations. compare the count of users, workspaces and datasources againts the corresponding object count in chorus_objects table. If they match, the migration has been run and we can skip it.

if ENV['force'] !=  'true'
  user_co_count = ChorusObject.where(:chorus_class_id => user_class.id).count
  ws_co_count = ChorusObject.where(:chorus_class_id =>  workspace_class.id).count
  datasource_co_count = ChorusObject.where(:chorus_class_id => datasource_class.id).count
  if user_co_count == User.count && ws_co_count == Workspace.count && datasource_co_count == DataSource.count
    puts ''
    puts "---- Skipping permissions migration. If you need to run permissions migration again use 'rake db:migrate_permissions force=true' from command line. ----"
    puts ''
    exit(0)
  end
end

puts ''
puts '==============================================================================='
puts 'This task may take few minutes to an hour based on the amount of data in your'
puts 'Chorus database. Please do not cancel this task until it is finished.'
puts '==============================================================================='
puts ''

# Groups
puts '---- Adding Default Group  ----'
default_group = Group.find_or_create_by_name(:name => 'default_group')


# Scope
puts ''
puts '---- Adding application_realm as Default Scope ----'
application_realm = ChorusScope.find_or_create_by_name(:name => 'application_realm')

puts ''
puts "===================== Adding Chorus Object =========================="

# delete all previous entries

puts ''
puts '--- Adding Users and children objects ----'

start = Time.now
columns = [:chorus_class_id, :instance_id, :owner_id, :parent_class_name, :parent_class_id, :parent_id, :chorus_scope_id]
values = []
count = User.count

User.find_in_batches({:batch_size => 5}) do |users|
  values = []
  users.each do |user|
    if ChorusClass.find_by_name(user.class.name) == nil
      ChorusClass.create(:name => user.class.name)
    end
    print '.'
    ChorusObject.create(:chorus_class_id => user_class.id, :instance_id => user.id, :chorus_scope_id => application_realm.id)
    user.groups << default_group unless user.groups.include?(default_group)
    count = count + user.gpdb_data_sources.count
    user.gpdb_data_sources.each do |data_source|
      if ChorusClass.find_by_name(data_source.class.name) == nil
        ChorusClass.create(:name => data_source.class.name)
      end
      print '.'
      values << [ChorusClass.find_by_name(data_source.class.name).id, data_source.id,  user.id, user.class.name, ChorusClass.find_by_name(user.class.name).id, user.id, application_realm.id]
      #ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(data_source.class.name).id, :instance_id => data_source.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id, :chorus_scope_id => application_realm.id)
    end
    count = count + user.oracle_data_sources.count
    user.oracle_data_sources.each do |data_source|
      if ChorusClass.find_by_name(data_source.class.name) == nil
        ChorusClass.create(:name => data_source.class.name)
      end
      print '.'
      values << [ChorusClass.find_by_name(data_source.class.name).id, data_source.id,  user.id, user.class.name, ChorusClass.find_by_name(user.class.name).id, user.id, application_realm.id]
      #ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(data_source.class.name).id, :instance_id => data_source.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id, :chorus_scope_id => application_realm.id)
    end
    count = count + user.jdbc_data_sources.count
    user.jdbc_data_sources.each do |data_source|
      if ChorusClass.find_by_name(data_source.class.name) == nil
        ChorusClass.create(:name => data_source.class.name)
      end
      print '.'
      values << [ChorusClass.find_by_name(data_source.class.name).id, data_source.id,  user.id, user.class.name, ChorusClass.find_by_name(user.class.name).id, user.id, application_realm.id]
      #ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(data_source.class.name).id, :instance_id => data_source.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id, :chorus_scope_id => application_realm.id)
    end
    count = count + user.pg_data_sources.count
    user.pg_data_sources.each do |data_source|
      if ChorusClass.find_by_name(data_source.class.name) == nil
        ChorusClass.create(:name => data_source.class.name)
      end
      print '.'
      values << [ChorusClass.find_by_name(data_source.class.name).id, data_source.id,  user.id, user.class.name, ChorusClass.find_by_name(user.class.name).id, user.id, application_realm.id]
      #ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(data_source.class.name).id, :instance_id => data_source.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id, :chorus_scope_id => application_realm.id)
    end
    count = count + user.hdfs_data_sources.count
    user.hdfs_data_sources.each do |data_source|
      if ChorusClass.find_by_name(data_source.class.name) == nil
        ChorusClass.create(:name => data_source.class.name)
      end
      print '.'
      values << [ChorusClass.find_by_name(data_source.class.name).id, data_source.id,  user.id, user.class.name, ChorusClass.find_by_name(user.class.name).id, user.id, application_realm.id]
      #ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(data_source.class.name).id, :instance_id => data_source.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id, :chorus_scope_id => application_realm.id)
    end
    count = count + user.gnip_data_sources.count
    user.gnip_data_sources.each do |data_source|
      if ChorusClass.find_by_name(data_source.class.name) == nil
        ChorusClass.create(:name => data_source.class.name)
      end
      print '.'
      values << [ChorusClass.find_by_name(data_source.class.name).id, data_source.id,  user.id, user.class.name, ChorusClass.find_by_name(user.class.name).id, user.id, application_realm.id]
      #ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(data_source.class.name).id, :instance_id => data_source.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id, :chorus_scope_id => application_realm.id)
    end
    count = count + user.data_source_accounts.count
    user.data_source_accounts.each do |data_source|
      if ChorusClass.find_by_name(data_source.class.name) == nil
        ChorusClass.create(:name => data_source.class.name)
      end
      print '.'
      values << [ChorusClass.find_by_name(data_source.class.name).id, data_source.id,  user.id, user.class.name, ChorusClass.find_by_name(user.class.name).id, user.id, application_realm.id]
      #ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(account.class.name).id, :instance_id => account.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id, :chorus_scope_id => application_realm.id)
    end
    count = count + user.memberships.count
    user.memberships.each do |member|
      if ChorusClass.find_by_name(member.class.name) == nil
        ChorusClass.create(:name => member.class.name)
      end
      print '.'
      values << [ChorusClass.find_by_name(member.class.name).id, member.id,  user.id, user.class.name, ChorusClass.find_by_name(user.class.name).id, user.id, application_realm.id]
      #ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(member.class.name).id, :instance_id => member.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id, :chorus_scope_id => application_realm.id)
    end
    count = count + user.owned_jobs.count
    user.owned_jobs.each do |job|
      if ChorusClass.find_by_name(job.class.name) == nil
        ChorusClass.create(:name => job.class.name)
      end
      print '.'
      values << [ChorusClass.find_by_name(job.class.name).id, job.id,  user.id, user.class.name, ChorusClass.find_by_name(user.class.name).id, user.id, application_realm.id]
      #ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(job.class.name).id, :instance_id => job.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id, :chorus_scope_id => application_realm.id)
    end
    count = count + user.activities.count
    user.activities.each do |activity|
      if ChorusClass.find_by_name(activity.class.name) == nil
        ChorusClass.create(:name => activity.class.name)
      end
      print '.'
      values << [ChorusClass.find_by_name(activity.class.name).id, activity.id,  user.id, user.class.name, ChorusClass.find_by_name(user.class.name).id, user.id, application_realm.id]
      #ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(activity.class.name).id, :instance_id => activity.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id, :chorus_scope_id => application_realm.id, :chorus_scope_id => application_realm.id)
    end
    count = count + user.events.count
    user.events.each do |event|
      if ChorusClass.find_by_name(event.class.name) == nil
        ChorusClass.create(:name => event.class.name)
      end
      print '.'
      values << [ChorusClass.find_by_name(event.class.name).id, event.id,  user.id, user.class.name, ChorusClass.find_by_name(user.class.name).id, user.id, application_realm.id]
      #ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(event.class.name).id, :instance_id => event.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id, :chorus_scope_id => application_realm.id)
    end
    count = count + user.notifications.count
    user.notifications.each do |notification|
      if ChorusClass.find_by_name(notification.class.name) == nil
        ChorusClass.create(:name => notification.class.name)
      end
      print '.'
      values << [ChorusClass.find_by_name(notification.class.name).id, notification.id,  user.id, user.class.name, ChorusClass.find_by_name(user.class.name).id, user.id, application_realm.id]
      #ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(notification.class.name).id, :instance_id => notification.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id, :chorus_scope_id => application_realm.id)
    end
    count = count + user.open_workfile_events.count
    user.open_workfile_events.each do |event|
      if ChorusClass.find_by_name(event.class.name) == nil
        ChorusClass.create(:name => event.class.name)
      end
      print '.'
      values << [ChorusClass.find_by_name(event.class.name).id, event.id,  user.id, user.class.name, ChorusClass.find_by_name(user.class.name).id, user.id, application_realm.id]
      #ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(event.class.name).id, :instance_id => event.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id, :chorus_scope_id => application_realm.id)
    end
  end
  #SQL_STMT = "INSERT INTO chorus_objects (chorus_class_id, instance_id, :owner_id, parent_class_name, parent_class_id, parent_id, chorus_scope_id) VALUES #{values.join(",")}"
  #CONN.execute(SQL_STMT)

  ChorusObject.import columns, values, :validate => true
end



stop = Time.now
puts " (#{count} rows, #{stop - start} seconds)"

puts ''
puts '--- Adding Workspace and  children objects ----'

start = Time.now
columns = [:chorus_class_id, :instance_id, :owner_id, :parent_class_name, :parent_class_id, :parent_id, :chorus_scope_id]
count = Workspace.count
Workspace.find_in_batches({:batch_size => 5}) do |workspaces|
  chorus_objects = []
  workspaces.each do |workspace|
    if ChorusClass.find_by_name(workspace.class.name) == nil
      ChorusClass.create(:name => workspace.class.name)
    end

    # Add owner as workspace role
    print '.'
    workspace_object = ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(workspace.class.name).id, :instance_id => workspace.id, :owner_id => workspace.owner.id, :chorus_scope_id => application_realm.id)
    object_role = ChorusObjectRole.create(:chorus_object_id => workspace_object.id, :user_id => workspace.owner.id, :role_id => owner_role.id)
    workspace_object.chorus_object_roles << object_role unless workspace_object.chorus_object_roles.include? object_role
    #workspace_object.chorus_object_roles << ChorusObjectRole.create(:chorus_object_id => workspace_object.id, :user_id => workspace.owner.id, :role_id => owner_role.id)

    # Add members as Project Managers
    workspace.members.each do |member|
      object_role = ChorusObjectRole.create(:chorus_object_id => workspace_object.id, :user_id => member.id, :role_id => project_manager_role.id)
      workspace_object.chorus_object_roles << object_role unless  workspace_object.chorus_object_roles.include? object_role

      #workspace_object.chorus_object_roles << ChorusObjectRole.create(:chorus_object_id => workspace_object.id, :user_id => member.id, :role_id => project_manager_role.id)
      #workspace_object.add_user_to_object_role(member, project_manager_role)
    end

    #workspace_object_role = ChorusObjectRole.create(:chorus_object_id => workspace_object.id, :user_id => workspace.owner.id, :role_id => owner_role.id)
    #workspace.owner.object_roles << workspace_object_role

    #children = %w(jobs milestones memberships workfiles activities events owned_notes comments chorus_views csv_files associated_datasets source_datasets all_imports imports tags)
    count = count + workspace.jobs.count
    workspace.jobs.each do |job|
      if ChorusClass.find_by_name(job.class.name) == nil
        ChorusClass.create(:name => job.class.name)
      end
      print '.'
      chorus_objects << [ChorusClass.find_by_name(job.class.name).id,  job.id, workspace.owner.id, workspace.class.name, ChorusClass.find_by_name(workspace.class.name).id,  workspace.id, application_realm.id]
      #chorus_objects << ChorusObject.new(:chorus_class_id => ChorusClass.find_by_name(job.class.name).id, :instance_id => job.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id, :chorus_scope_id => application_realm.id)
    end
    count = count + workspace.milestones.count
    workspace.milestones.each do |milestone|
      if ChorusClass.find_by_name(milestone.class.name) == nil
        ChorusClass.create(:name => milestone.class.name)
      end
      print '.'
      chorus_objects << [ChorusClass.find_by_name(milestone.class.name).id,  milestone.id, workspace.owner.id, workspace.class.name, ChorusClass.find_by_name(workspace.class.name).id,  workspace.id, application_realm.id]
      #chorus_objects << ChorusObject.new(:chorus_class_id => ChorusClass.find_by_name(milestone.class.name).id, :instance_id => milestone.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id, :chorus_scope_id => application_realm.id)
    end
    count = count + workspace.memberships.count
    workspace.memberships.each do |membership|
      if ChorusClass.find_by_name(membership.class.name) == nil
        print '.'
        ChorusClass.create(:name => membership.class.name)
      end
      print '.'
      chorus_objects << [ChorusClass.find_by_name(membership.class.name).id,  membership.id, workspace.owner.id, workspace.class.name, ChorusClass.find_by_name(workspace.class.name).id,  workspace.id, application_realm.id]
      #chorus_objects << ChorusObject.new(:chorus_class_id => ChorusClass.find_by_name(membership.class.name).id, :instance_id => membership.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id, :chorus_scope_id => application_realm.id)
    end
    count = count + workspace.workfiles.count
    workspace.workfiles.each do |workfile|
      if ChorusClass.find_by_name(workfile.class.name) == nil
        print '.'
        ChorusClass.create(:name => workfile.class.name)
      end
      print '.'
      chorus_objects << [ChorusClass.find_by_name(workfile.class.name).id,  workfile.id, workspace.owner.id, workspace.class.name, ChorusClass.find_by_name(workspace.class.name).id,  workspace.id, application_realm.id]
      #chorus_objects << ChorusObject.new(:chorus_class_id => ChorusClass.find_by_name(workfile.class.name).id, :instance_id => workfile.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id, :chorus_scope_id => application_realm.id)
      count = count + workfile.activities.count
      workfile.activities.each do |activity|
        if ChorusClass.find_by_name(activity.class.name) == nil
          print '.'
          ChorusClass.create(:name => activity.class.name)
        end
        print '.'
        chorus_objects << [ChorusClass.find_by_name(activity.class.name).id,  activity.id, workspace.owner.id, workfile.class.name, ChorusClass.find_by_name(workfile.class.name).id,  workfile.id, application_realm.id]
        #chorus_objects << ChorusObject.new(:chorus_class_id => ChorusClass.find_by_name(activity.class.name).id, :instance_id  => activity.id, :owner_id => workspace.owner.id,  :parent_class_name => workfile.class.name, :parent_class_id => ChorusClass.find_by_name(workfile.class.name).id, :parent_id => workfile.id, :chorus_scope_id => application_realm.id)
      end
      count = count + workfile.events.count
      workfile.events.each do |event|
        if ChorusClass.find_by_name(event.class.name) == nil
          print '.'
          ChorusClass.create(:name => event.class.name)
        end
        print '.'
        chorus_objects << [ChorusClass.find_by_name(event.class.name).id,  event.id, workspace.owner.id, workfile.class.name, ChorusClass.find_by_name(workfile.class.name).id,  workfile.id, application_realm.id]
        #chorus_objects << ChorusObject.new(:chorus_class_id => ChorusClass.find_by_name(event.class.name).id, :instance_id  => event.id, :owner_id => workspace.owner.id,  :parent_class_name => workfile.class.name, :parent_class_id => ChorusClass.find_by_name(workfile.class.name).id, :parent_id => workfile.id, :chorus_scope_id => application_realm.id)
      end
      count = count + workfile.open_workfile_events.count
      workfile.open_workfile_events.each do |event|
        if ChorusClass.find_by_name(event.class.name) == nil
          ChorusClass.create(:name => event.class.name)
        end
        print '.'
        chorus_objects << [ChorusClass.find_by_name(event.class.name).id,  event.id, workspace.owner.id, workfile.class.name, ChorusClass.find_by_name(workfile.class.name).id,  workfile.id, application_realm.id]
        #chorus_objects << ChorusObject.new(:chorus_class_id => ChorusClass.find_by_name(event.class.name).id, :instance_id  => event.id, :owner_id => workspace.owner.id,  :parent_class_name => workfile.class.name, :parent_class_id => ChorusClass.find_by_name(workfile.class.name).id, :parent_id => workfile.id, :chorus_scope_id => application_realm.id)
      end
      count = count + workfile.comments.count
      workfile.comments.each do |comment|
        if ChorusClass.find_by_name(comment.class.name) == nil
          ChorusClass.create(:name => comment.class.name)
        end
        print '.'
        chorus_objects << [ChorusClass.find_by_name(comment.class.name).id,  comment.id, workspace.owner.id, workfile.class.name, ChorusClass.find_by_name(workfile.class.name).id,  workfile.id, application_realm.id]
        #chorus_objects << ChorusObject.new(:chorus_class_id =>  ChorusClass.find_by_name(comment.class.name).id, :instance_id => comment.id, :owner_id => workfile.owner.id,  :parent_class_name => workfile.class.name, :parent_class_id => ChorusClass.find_by_name(workfile.class.name).id, :parent_id => workfile.id, :chorus_scope_id => application_realm.id)
      end
    end
    count = count + workspace.activities.count
    workspace.activities.each do |activity|
      if ChorusClass.find_by_name(activity.class.name) == nil
        ChorusClass.create(:name => activity.class.name)
      end
      print '.'
      chorus_objects << [ChorusClass.find_by_name(activity.class.name).id,  activity.id, workspace.owner.id, workspace.class.name, ChorusClass.find_by_name(workspace.class.name).id,  workspace.id, application_realm.id]
      #chorus_objects << ChorusObject.new(:chorus_class_id => ChorusClass.find_by_name(activity.class.name).id, :instance_id => activity.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id, :chorus_scope_id => application_realm.id)
    end
    #TODO: RPG. Don't know how to deal with events of differnt types in permissions framework. For now adding them as sub classes of (Events::Base)
    count = count + workspace.events.count
    workspace.events.each do |event|
      if ChorusClass.find_by_name(event.class.name) == nil
        ChorusClass.create(:name => event.class.name)
      end
      print '.'
      chorus_objects << [ChorusClass.find_by_name(event.class.name).id,  event.id, workspace.owner.id, workspace.class.name, ChorusClass.find_by_name(workspace.class.name).id,  workspace.id, application_realm.id]
      #ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(event.class.name).id, :instance_id => event.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id, :chorus_scope_id => application_realm.id)
    end
    count = count + workspace.owned_notes.count
    workspace.owned_notes.each do |note|
      if ChorusClass.find_by_name(note.class.name) == nil
        ChorusClass.create(:name => note.class.name)
      end
      print '.'
      chorus_objects << [ChorusClass.find_by_name(note.class.name).id,  note.id, workspace.owner.id, workspace.class.name, ChorusClass.find_by_name(workspace.class.name).id,  workspace.id, application_realm.id]
      #chorus_objects << ChorusObject.new(:chorus_class_id => ChorusClass.find_by_name(note.class.name).id, :instance_id => note.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id, :chorus_scope_id => application_realm.id)
    end
    count = count + workspace.comments.count
    workspace.comments.each do |comment|
      if ChorusClass.find_by_name(comment.class.name) == nil
        ChorusClass.create(:name => comment.class.name)
      end
      print '.'
      chorus_objects << [ChorusClass.find_by_name(comment.class.name).id,  comment.id, workspace.owner.id, workspace.class.name, ChorusClass.find_by_name(workspace.class.name).id,  workspace.id, application_realm.id]
      #chorus_objects << ChorusObject.new(:chorus_class_id => ChorusClass.find_by_name(comment.class.name).id, :instance_id => comment.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id, :chorus_scope_id => application_realm.id)
    end
    count = count + workspace.chorus_views.count
    workspace.chorus_views.each do |view|
      if ChorusClass.find_by_name(view.class.name) == nil
        ChorusClass.create(:name => view.class.name)
      end
      print '.'
      chorus_objects << [ChorusClass.find_by_name(view.class.name).id,  view.id, workspace.owner.id, workspace.class.name, ChorusClass.find_by_name(workspace.class.name).id,  workspace.id, application_realm.id]
      #chorus_objects << ChorusObject.new(:chorus_class_id => ChorusClass.find_by_name(view.class.name).id, :instance_id => view.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id, :chorus_scope_id => application_realm.id)
    end
    count = count + workspace.csv_files.count
    workspace.csv_files.each do |file|
      if ChorusClass.find_by_name(file.class.name) == nil
        ChorusClass.create(:name => file.class.name)
      end
      print '.'
      chorus_objects << [ChorusClass.find_by_name(file.class.name).id,  file.id, workspace.owner.id, workspace.class.name, ChorusClass.find_by_name(workspace.class.name).id,  workspace.id, application_realm.id]
      #chorus_objects << ChorusObject.new(:chorus_class_id => ChorusClass.find_by_name(file.class.name).id, :instance_id => file.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id, :chorus_scope_id => application_realm.id)
    end
    count = count + workspace.associated_datasets.count
    workspace.associated_datasets.each do |dataset|
      if ChorusClass.find_by_name(dataset.class.name) == nil
        ChorusClass.create(:name => dataset.class.name)
      end
      print '.'
      chorus_objects << [ChorusClass.find_by_name(dataset.class.name).id,  dataset.id, workspace.owner.id, workspace.class.name, ChorusClass.find_by_name(workspace.class.name).id,  workspace.id, application_realm.id]
      #chorus_objects << ChorusObject.new(:chorus_class_id => ChorusClass.find_by_name(dataset.class.name).id, :instance_id => dataset.id, :owner_id => workspace.owner.id, :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id, :chorus_scope_id => application_realm.id)
    end
    count = count + workspace.source_datasets.count
    workspace.source_datasets.each do |dataset|
      if ChorusClass.find_by_name(dataset.class.name) == nil
        ChorusClass.create(:name => dataset.class.name)
      end
      print '.'
      chorus_objects << [ChorusClass.find_by_name(dataset.class.name).id,  dataset.id, workspace.owner.id, workspace.class.name, ChorusClass.find_by_name(workspace.class.name).id,  workspace.id, application_realm.id]
      #chorus_objects << ChorusObject.new(:chorus_class_id => ChorusClass.find_by_name(dataset.class.name).id, :instance_id => dataset.id, :owner_id => workspace.owner.id, :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id, :chorus_scope_id => application_realm.id)
    end
    count = count + workspace.all_imports.count
    workspace.all_imports.each do |import|
      if ChorusClass.find_by_name(import.class.name) == nil
        ChorusClass.create(:name => import.class.name)
      end
      print '.'
      chorus_objects << [ChorusClass.find_by_name(import.class.name).id,  import.id, workspace.owner.id, workspace.class.name, ChorusClass.find_by_name(workspace.class.name).id,  workspace.id, application_realm.id]
      #chorus_objects << ChorusObject.new(:chorus_class_id => ChorusClass.find_by_name(import.class.name).id, :instance_id => import.id, :owner_id => workspace.owner.id, :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id, :chorus_scope_id => application_realm.id)
    end
    count = count + workspace.imports.count
    workspace.imports.each do |import|
      if ChorusClass.find_by_name(import.class.name) == nil
        ChorusClass.create(:name => import.class.name)
      end
      print '.'
      chorus_objects << [ChorusClass.find_by_name(import.class.name).id,  import.id, workspace.owner.id, workspace.class.name, ChorusClass.find_by_name(workspace.class.name).id,  workspace.id, application_realm.id]
      #chorus_objects << ChorusObject.new(:chorus_class_id => ChorusClass.find_by_name(import.class.name).id, :instance_id => import.id, :owner_id => workspace.owner.id, :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id, :chorus_scope_id => application_realm.id)
    end
    count = count + workspace.tags.count
    workspace.tags.each do |tag|
      if ChorusClass.find_by_name(tag.class.name) == nil
        ChorusClass.create(:name => tag.class.name)
      end
      print '.'
      chorus_objects << [ChorusClass.find_by_name(tag.class.name).id,  tag.id, workspace.owner.id, workspace.class.name, ChorusClass.find_by_name(workspace.class.name).id,  workspace.id, application_realm.id]
      #chorus_objects << ChorusObject.new(:chorus_class_id => ChorusClass.find_by_name(tag.class.name).id, :instance_id => tag.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id, :chorus_scope_id => application_realm.id)
    end

  end
  ChorusObject.import columns, chorus_objects, :validate => true
end



stop = Time.now
puts " (#{count} rows, #{stop - start} seconds)"


puts ''
puts '--- Adding Data Sources  ----'
columns = [:chorus_class_id, :instance_id, :owner_id, :chorus_scope_id]
start = Time.now
DataSource.find_in_batches({:batch_size => 1000}) do |datasources|
  chorus_objects = []
  datasources.each do |data_source|
    print '.'
    if data_source.owner != nil
      chorus_objects << [datasource_class.id, data_source.id, data_source.owner.id, application_realm.id]
    else
      chorus_objects << [datasource_class.id, data_source.id, nil, application_realm.id]
    end
    #ChorusObject.create(:chorus_class_id => datasource_class.id, :instance_id => data_source.id, :owner_id => data_source.owner.id, :chorus_scope_id => application_realm.id)
  end
  ChorusObject.import columns, chorus_objects, :validate => true
end
stop = Time.now
puts " (#{DataSource.count} rows, #{stop - start} seconds)"

puts ''
puts '--- Adding Databases  ----'
columns = [:chorus_class_id, :instance_id, :chorus_scope_id, :owner_id, :parent_class_name, :parent_class_id, :parent_id]
start = Time.now
Database.find_in_batches({:batch_size => 1000}) do |databases|
  chorus_objects = []
  databases.each do |database|
    print '.'
    co = []
    co << [database_class.id, database.id, application_realm.id]
    if database.data_source != nil
      if database.data_source.owner != nil
        co << [database.data_source.owner.id,  datasource_class.name, datasource_class.id, database.data_source.id]
      else
        co << [nil,  datasource_class.name, datasource_class.id, database.data_source.id]
      end
    else
      co << [nil, nil, nil, nil]
    end
    chorus_objects << co.flatten!
  end
  ChorusObject.import columns, chorus_objects, :validate => true
end
stop = Time.now
puts " (#{Database.count} rows, #{stop - start} seconds)"

puts ''
puts '--- Adding Hdfs Data Sources  ----'
columns = [:chorus_class_id, :instance_id, :owner_id, :chorus_scope_id]
start = Time.now
HdfsDataSource.find_in_batches({:batch_size => 1000}) do |datasources|
  chorus_objects = []
  datasources.each do |data_source|
    print '.'
    if data_source.owner != nil
      chorus_objects << [hdfs_data_source_class.id, data_source.id, data_source.owner.id, application_realm.id]
    else
      chorus_objects << [hdfs_data_source_class.id, data_source.id, nil, application_realm.id]
    end
  end
  ChorusObject.import columns, chorus_objects, :validate => true
end
stop = Time.now
puts " (#{HdfsDataSource.count} rows, #{stop - start} seconds)"

# Removing adding HdfsEntry. It will be controlled by the parent hdfs_data_source object
# puts ''
# puts '--- Adding HdfsEntry  ----'
# columns = [:chorus_class_id, :instance_id, :chorus_scope_id, :owner_id, :parent_class_name, :parent_class_id, :parent_id]
# start = Time.now
# HdfsEntry.find_in_batches({:batch_size => 2500}) do |entries|
#   chorus_objects = []
#   entries.each do |entry|
#     print '.'
#     co = []
#     co << [hdfs_entry_class.id, entry.id, application_realm.id]
#     #co = ChorusObject.create(:chorus_class_id => hdfs_entry_class.id, :instance_id => dataset.id,:chorus_scope_id => application_realm.id)
#     if entry.hdfs_data_source != nil
#       co << [entry.hdfs_data_source.owner.id,  hdfs_data_source_class.name, hdfs_data_source_class.id, entry.hdfs_data_source.id]
#       #co.update_attributes(:owner_id => dataset.workspace.owner.id, :parent_class_name => workspace_class.name, :parent_class_id => workspace_class.id, :parent_id => dataset.workspace.id)
#     else
#       co << [nil, nil, nil, nil]
#     end
#     chorus_objects << co.flatten!
#   end
#   ChorusObject.import columns, chorus_objects, :validate => false
# end
# stop = Time.now
# puts "(#{HdfsEntry.count} rows, #{stop - start} seconds)"


puts ''
puts '--- Adding ChorusView  ----'
columns = [:chorus_class_id, :instance_id, :chorus_scope_id, :owner_id, :parent_class_name, :parent_class_id, :parent_id]
start = Time.now
ChorusView.find_in_batches({:batch_size => 2500}) do |views|
  chorus_objects =  []
  views.each do |dataset|
    print '.'
    co = []
    co << [chorus_view_class.id, dataset.id, application_realm.id]
    #co = ChorusObject.create(:chorus_class_id => chorus_view_class.id, :instance_id => dataset.id, :chorus_scope_id => application_realm.id)
    if dataset.workspace != nil
      co << [dataset.workspace.owner.id,  workspace_class.name, workspace_class.id, dataset.workspace.id]
      #co.update_attributes(:owner_id => dataset.workspace.owner.id, :parent_class_name => workspace_class.name, :parent_class_id => workspace_class.id, :parent_id => dataset.workspace.id)
    else
      co << [nil, nil, nil, nil]
    end
    chorus_objects << co.flatten!
  end
  ChorusObject.import columns, chorus_objects, :validate => true
end
stop = Time.now
puts " (#{ChorusView.count} rows, #{stop - start} seconds)"


puts ''
puts '--- Adding GpdbView  ----'
columns = [:chorus_class_id, :instance_id, :chorus_scope_id, :owner_id, :parent_class_name, :parent_class_id, :parent_id]
start = Time.now

GpdbView.find_in_batches({:batch_size => 2500}) do |views|
  chorus_objects = []
  views.each do |dataset|
    print '.'
    co = []
    co << [gpdb_view_class.id, dataset.id, application_realm.id]
    #co = ChorusObject.create(:chorus_class_id => gpdb_view_class.id, :instance_id => dataset.id, :chorus_scope_id => application_realm.id)
    if dataset.workspace != nil
      co << [dataset.workspace.owner.id,  workspace_class.name, workspace_class.id, dataset.workspace.id]
      #co.update_attributes(:owner_id => dataset.workspace.owner.id, :parent_class_name => workspace_class.name, :parent_class_id => workspace_class.id, :parent_id => dataset.workspace.id)
    else
      co << [nil, nil, nil, nil]
    end
    chorus_objects << co.flatten!
  end
  ChorusObject.import columns, chorus_objects, :validate => true
end
stop = Time.now
puts "(#{GpdbView.count} rows, #{stop - start} seconds)"


puts ''
puts '--- Adding GpdbTable  ----'
columns = [:chorus_class_id, :instance_id, :chorus_scope_id, :owner_id, :parent_class_name, :parent_class_id, :parent_id]
start = Time.now

GpdbTable.find_in_batches({:batch_size => 2500}) do |views|
  chorus_objects = []
  views.each do |dataset|
    print '.'
    co = []
    co << [gpdb_table_class.id, dataset.id, application_realm.id]
    #co = ChorusObject.create(:chorus_class_id => gpdb_table_class.id, :instance_id => dataset.id, :chorus_scope_id => application_realm.id)
    if dataset.workspace != nil
      co << [dataset.workspace.owner.id,  workspace_class.name, workspace_class.id, dataset.workspace.id]
      #co.update_attributes(:owner_id => dataset.workspace.owner.id, :parent_class_name => workspace_class.name, :parent_class_id => workspace_class.id, :parent_id => dataset.workspace.id)
    else
      co << [nil, nil, nil, nil]
    end
    chorus_objects << co.flatten!
  end
  ChorusObject.import columns, chorus_objects, :validate => true
end

stop = Time.now
puts " (#{GpdbTable.count} rows, #{stop - start} seconds)"


puts ''
puts '--- Adding PgTable  ----'
columns = [:chorus_class_id, :instance_id, :chorus_scope_id, :owner_id, :parent_class_name, :parent_class_id, :parent_id]
start = Time.now

PgTable.find_in_batches({:batch_size => 2500}) do |views|
  chorus_objects = []
  views.each do |dataset|
    print '.'
    co = []
    co << [pg_table_class.id, dataset.id, application_realm.id]
    #co = ChorusObject.create(:chorus_class_id => pg_table_class.id, :instance_id => dataset.id, :chorus_scope_id => application_realm.id)
    if dataset.workspace != nil
      co << [dataset.workspace.owner.id,  workspace_class.name, workspace_class.id, dataset.workspace.id]
      #co.update_attributes(:owner_id => dataset.workspace.owner.id, :parent_class_name => workspace_class.name, :parent_class_id => workspace_class.id, :parent_id => dataset.workspace.id)
    else
      co << [nil, nil, nil, nil]
    end
    chorus_objects << co.flatten!
  end
  ChorusObject.import columns, chorus_objects, :validate => true
end

stop = Time.now
puts " (#{PgTable.count} rows, #{stop - start} seconds)"

puts ''
puts '--- Adding PgView  ----'
columns = [:chorus_class_id, :instance_id, :chorus_scope_id, :owner_id, :parent_class_name, :parent_class_id, :parent_id]
start = Time.now

PgView.find_in_batches({:batch_size => 2500}) do |views|
  chorus_objects = []
  views.each do |dataset|
    print '.'
    co = []
    co << [pg_view_class.id, dataset.id, application_realm.id]
    #co = ChorusObject.create(:chorus_class_id => pg_view_class.id, :instance_id => dataset.id, :chorus_scope_id => application_realm.id)
    if dataset.workspace != nil
      co << [dataset.workspace.owner.id,  workspace_class.name, workspace_class.id, dataset.workspace.id]
      #co.update_attributes(:owner_id => dataset.workspace.owner.id, :parent_class_name => workspace_class.name, :parent_class_id => workspace_class.id, :parent_id => dataset.workspace.id)
    else
      co << [nil, nil, nil, nil]
    end
    chorus_objects << co.flatten!
  end
  ChorusObject.import columns, chorus_objects, :validate => true
end
stop = Time.now
puts " (#{PgView.count} rows, #{stop - start} seconds)"

puts ''
puts '--- Adding HdfsDataset  ----'
columns = [:chorus_class_id, :instance_id, :chorus_scope_id, :owner_id, :parent_class_name, :parent_class_id, :parent_id]
start = Time.now

HdfsDataset.find_in_batches({:batch_size => 2500}) do |views|
  chorus_objects = []
  views.each do |dataset|
    print '.'
    co = []
    co << [hdfs_dataset_class.id, dataset.id, application_realm.id]
    #co = ChorusObject.create(:chorus_class_id => hdfs_dataset_class.id, :instance_id => dataset.id, :chorus_scope_id => application_realm.id)
    if dataset.workspace != nil
      co << [dataset.workspace.owner.id,  workspace_class.name, workspace_class.id, dataset.workspace.id]
      #co.update_attributes(:owner_id => dataset.workspace.owner.id, :parent_class_name => workspace_class.name, :parent_class_id => workspace_class.id, :parent_id => dataset.workspace.id)
    else
      co << [nil, nil, nil, nil]
    end
    chorus_objects << co.flatten!
  end
  ChorusObject.import columns, chorus_objects, :validate => true
end
stop = Time.now
puts " (#{HdfsDataset.count} rows, #{stop - start} seconds)"

puts ''
puts '--- Adding GpdbDataset  ----'
columns = [:chorus_class_id, :instance_id, :chorus_scope_id, :owner_id, :parent_class_name, :parent_class_id, :parent_id]
start = Time.now

GpdbDataset.find_in_batches({:batch_size => 2500}) do |views|
  chorus_objects = []
  views.each do |dataset|
    print '.'
    co = []
    co << [gpdb_dataset_class.id, dataset.id, application_realm.id]
    #co = ChorusObject.create(:chorus_class_id => gpdb_dataset_class.id, :instance_id => dataset.id, :chorus_scope_id => application_realm.id)
    if dataset.workspace != nil
      co << [dataset.workspace.owner.id,  workspace_class.name, workspace_class.id, dataset.workspace.id]
      #co.update_attributes(:owner_id => dataset.workspace.owner.id, :parent_class_name => workspace_class.name, :parent_class_id => workspace_class.id, :parent_id => dataset.workspace.id)
    else
      co << [nil, nil, nil, nil]
    end
    chorus_objects << co.flatten!
  end
  ChorusObject.import columns, chorus_objects, :validate => true
end
stop = Time.now
puts " (#{GpdbDataset.count} rows, #{stop - start} seconds)"


puts ''
puts '--- Adding JdbcDataset  ----'
columns = [:chorus_class_id, :instance_id, :chorus_scope_id, :owner_id, :parent_class_name, :parent_class_id, :parent_id]
start = Time.now

JdbcDataset.find_in_batches({:batch_size => 2500}) do |views|
  chorus_objects = []
  views.each do |dataset|
    print '.'
    co = []
    co << [jdbc_dataset_class.id, dataset.id, application_realm.id]
    #co = ChorusObject.create(:chorus_class_id => jdbc_dataset_class.id, :instance_id => dataset.id, :chorus_scope_id => application_realm.id)
    if dataset.workspace != nil
      co << [dataset.workspace.owner.id,  workspace_class.name, workspace_class.id, dataset.workspace.id]
      #co.update_attributes(:owner_id => dataset.workspace.owner.id, :parent_class_name => workspace_class.name, :parent_class_id => workspace_class.id, :parent_id => dataset.workspace.id)
    else
      co << [nil, nil, nil, nil]
    end
    chorus_objects << co.flatten!
  end
  ChorusObject.import columns, chorus_objects, :validate => true
end
stop = Time.now
puts " (#{JdbcDataset.count} rows, #{stop - start} seconds)"

puts ''
puts '--- Adding GpdbSchema  ----'
columns = [:chorus_class_id, :instance_id, :chorus_scope_id]
start = Time.now

GpdbSchema.find_in_batches({:batch_size => 2500}) do |views|
  chorus_objects = []
  views.each do |dataset|
    print '.'
    co = []
    co << [gpdb_schema_class.id, dataset.id, application_realm.id]
    chorus_objects << co.flatten!
  end
  ChorusObject.import columns, chorus_objects, :validate => true
end
stop = Time.now
puts " (#{GpdbSchema.count} rows, #{stop - start} seconds)"


puts ''
puts '--- Adding PgSchema  ----'
columns = [:chorus_class_id, :instance_id, :chorus_scope_id]
start = Time.now

PgSchema.find_in_batches({:batch_size => 2500}) do |views|
  chorus_objects = []
  views.each do |dataset|
    print '.'
    co = []
    co << [pg_schema_class.id, dataset.id, application_realm.id]
    #co = ChorusObject.create(:chorus_class_id => pg_schema_class.id, :instance_id => dataset.id, :chorus_scope_id => application_realm.id)
    chorus_objects << co.flatten!
  end
  ChorusObject.import columns, chorus_objects, :validate => true
end
stop = Time.now
puts " (#{PgSchema.count} rows, #{stop - start} seconds)"

# puts ''
# puts '--- Assign application_realm scope to all objects ---'
#
# ChorusObject.all.each do |chorus_object|
#   chorus_object.chorus_scope = application_realm
#   chorus_object.save!
# end


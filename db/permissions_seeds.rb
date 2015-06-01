# Seed roles groups and permissions
# roles
puts '---- Adding Roles ----'
admin_role = Role.create(:name => 'admin')
developer_role = Role.create(:name => 'developer')
collaborator_role = Role.create(:name => 'collaborator')
site_admin_role = Role.create(:name => 'site_administrator')
app_admin_role = Role.create(:name => 'application_administrator')
app_manager_role = Role.create(:name => 'application_manager')
workflow_developer_role = Role.create(:name => 'workflow_developer_manager')
project_manager_role = Role.create(:name => 'project_manager')
project_developer_role = Role.create(:name => 'project_developer')
contributor_role = Role.create(:name => 'contributor')
data_scientist_role = Role.create(:name => 'data_scientist')


chorusadmin = User.find_by_username("chorusadmin")

admin_role.users << chorusadmin


# Groups
puts '---- Adding Default Group  ----'
default_group = Group.create(:name => 'default_group')
Role.all.each do |role|
    role.groups << default_group
end

# Scope
puts '---- Adding Default Scope ----'
default_scope = Scope.create(:name => 'default_scope')

# permissions
User.set_permissions_for [admin_role], [:create, :destroy, :ldap, :update]
Events::Note.set_permissions_for [admin_role], [:destroy, :demote_from_insight, :update]
Workspace.set_permissions_for [admin_role], [:show, :update, :destroy, :admin]
Workspace.set_permissions_for [developer_role], [:show, :update, :create_workflow]
DataSource.set_permissions_for [admin_role], [:edit]

puts '---- Adding Chorus object classes  ----'
ChorusClass.create(
    [
        {:name => 'activity'},
        {:name => 'alpine_workfile'},
        {:name => 'associated_dataset'},
        {:name => 'chorus_view'},
        {:name => 'chorus_workfile'},
        {:name => 'comment'},
        {:name => 'csv_file'},
        {:name => 'csv_import'},
        {:name => 'dashboard'},
        {:name => 'dashboard_config'},
        {:name => 'dashboard_item'},
        {:name => 'data_source'},
        {:name => 'data_source_account'},
        {:name => 'database'},
        {:name => 'dataset'},
        {:name => 'database_column'},
        {:name => 'datasets_note'},
        {:name => 'external_table'},
        {:name => 'gnip_data_source'},
        {:name => 'gnip_import'},
        {:name => 'gpdb_column_statistics'},
        {:name => 'gpdb_data_source'},
        {:name => 'gpdb_database'},
        {:name => 'gpdb_dataset_column'},
        {:name => 'gpdb_schena'},
        {:name => 'gpdb_table'},
        {:name => 'gpdb_view'},
        {:name => 'greenplum_sql_result'},
        {:name => 'hdfs_data_source'},
        {:name => 'hdfs_dataset'},
        {:name => 'hdfs_dataset_statistics'},
        {:name => 'hdfs_entry'},
        {:name => 'hdfs_entry_statistics'},
        {:name => 'hdfs_file'},
        {:name => 'hdfs_import'},
        {:name => 'insight'},
        {:name => 'import'},
        {:name => 'import_source_data_task'},
        {:name => 'import_source_task_result'},
        {:name => 'imoort_template'},
        {:name => 'jdbc_data_source'},
        {:name => 'jdbc_dataset'},
        {:name => 'jdbc_dataset_column'},
        {:name => 'jdbc_hive_data_source'},
        {:name => 'jdbc_schema'},
        {:name => 'jdbc_sql_result'},
        {:name => 'jdbc_table'},
        {:name => 'jdbc_view'},
        {:name => 'job'},
        {:name => 'job_result'},
        {:name => 'job_task'},
        {:name => 'job_task_result'},
        {:name => 'ldap_config'},
        {:name => 'license'},
        {:name => 'linked_tableau_workfile'},
        {:name => 'membership'},
        {:name => 'milestone'},
        {:name => 'my_workspace_search'},
        {:name => 'note'},
        {:name => 'notes_workflow_result'},
        {:name => 'notes_workfile'},
        {:name => 'notification'},
        {:name => 'open_worlfile_event'},
        {:name => 'operation'},
        {:name => 'oracle_data_source'},
        {:name => 'oracle_dataset'},
        {:name => 'oracle_dataset_column'},
        {:name => 'oracle_schema'},
        {:name => 'oracle_sql_result'},
        {:name => 'oracle_table'},
        {:name => 'oracle_view'},
        {:name => 'permission'},
        {:name => 'pg_data_source'},
        {:name => 'pg_database'},
        {:name => 'pg_dataset'},
        {:name => 'pg_dataset_column'},
        {:name => 'pg_schema'},
        {:name => 'pg_table'},
        {:name => 'pg_view'},
        {:name => 'relational_dataset'},
        {:name => 'role'},
        {:name => 'run_sql_workfile_task'},
        {:name => 'run_workflow_task'},
        {:name => 'run_workflow_task_result'},
        {:name => 'sandbox'},
        {:name => 'schema'},
        {:name => 'schema_function'},
        {:name => 'schema_import'},
        {:name => 'scope'},
        {:name => 'search'},
        {:name => 'session'},
        {:name => 'sql_result'},
        {:name => 'sql_value_parser'},
        {:name => 'system_status'},
        {:name => 'tableau_publisher'},
        {:name => 'tableau_workbook_publication'},
        {:name => 'tag'},
        {:name => 'tagging'},
        {:name => 'type_ahead_search'},
        {:name => 'upload'},
        {:name => 'user'},
        {:name => 'visualization'},
        {:name => 'workfile'},
        {:name => 'workfile_draft'},
        {:name => 'workfile_execution_location'},
        {:name => 'workfile_version'},
        {:name => 'workspace'},
        {:name => 'workspace_import'},
        {:name => 'workspace_search'},
    ]
)


#models/dashboard

ChorusClass.create(
    [
        {:name => 'recent_workfiles'},
        {:name => 'site_snapshot'},
        {:name => 'workspace_activity'}

    ]
)

#models/events

ChorusClass.create(
    [
        {:name => 'base'},
        {:name => 'chorus_view_changed'},
        {:name => 'chorus_view_created'},
        {:name => 'credentials_invalid'},
        {:name => 'data_source_changed_name'},
        {:name => 'data_source_changed_owner'},
        {:name => 'data_source_created'},
        {:name => 'data_source_deleted'},
        {:name => 'file_import_created'},
        {:name => 'file_import_failed'},

    # TBD. Can these event types be handle in better way?

    ]
)

#model/visualization

ChorusClass.create(
    [
        {:name => 'boxplot'},
        {:name => 'frequency'},
        {:name => 'heatmap'},
        {:name => 'histograp'},
        {:name => 'timeseries'}

    ]
)

workspace_class = ChorusClass.where(:name => 'workspace').first
data_source_class = ChorusClass.where(:name => 'data_source').first
database_class = ChorusClass.where(:name => 'database').first
job_class  = ChorusClass.where(:name => 'job').first
milestone_class = ChorusClass.where(:name => 'milestone').first
membership_class = ChorusClass.where(:name => 'membership').first
workfile_class = ChorusClass.where(:name => 'workfile').first
activity_class = ChorusClass.where(:name => 'activity').first
event_class = ChorusClass.where(:name => 'base').first
note_class = ChorusClass.where(:name => 'note').first
comment_class = ChorusClass.where(:name => 'comment').first
chorus_view_class = ChorusClass.where(:name => 'chorus_view').first
sandbox_class = ChorusClass.where(:name => 'sandbox').first
csv_file_class = ChorusClass.where(:name => 'csv_file').first
dataset_class = ChorusClass.where(:name => 'dataset').first
associated_dataset_class = ChorusClass.where(:name => 'associated_dataset').first
import_class = ChorusClass.where(:name => 'import').first
tag_class = ChorusClass.where(:name => 'tag').first

job_class.update_attributes({:parent_class_name => 'workspace'}, {:parent_class_id => workspace_class.id} )
milestone_class.update_attributes({:parent_class_name => 'workspace'}, {:parent_class_id => workspace_class.id} )
membership_class.update_attributes({:parent_class_name => 'workspace'}, {:parent_class_id => workspace_class.id} )
workfile_class.update_attributes({:parent_class_name => 'workspace'}, {:parent_class_id => workspace_class.id} )
activity_class.update_attributes({:parent_class_name => 'workspace'}, {:parent_class_id => workspace_class.id} )
event_class.update_attributes({:parent_class_name => 'workspace'}, {:parent_class_id => workspace_class.id} )
note_class.update_attributes({:parent_class_name => 'workspace'}, {:parent_class_id => workspace_class.id} )
comment_class.update_attributes({:parent_class_name => 'workspace'}, {:parent_class_id => workspace_class.id} )
chorus_view_class.update_attributes({:parent_class_name => 'workspace'}, {:parent_class_id => workspace_class.id} )
sandbox_class.update_attributes({:parent_class_name => 'workspace'}, {:parent_class_id => workspace_class.id} )
csv_file_class.update_attributes({:parent_class_name => 'workspace'}, {:parent_class_id => workspace_class.id} )
dataset_class.update_attributes({:parent_class_name => 'workspace'}, {:parent_class_id => workspace_class.id} )
associated_dataset_class.update_attributes({:parent_class_name => 'workspace'}, {:parent_class_id => workspace_class.id} )
import_class.update_attributes({:parent_class_name => 'workspace'}, {:parent_class_id => workspace_class.id} )


puts '---- Adding Chorus objects  ----'

Workspace.all.each do |workspace|
    ChorusObject.create(:chorus_class_id => workspace_class.id, :instance_id => workspace.id, :owner_id => workspace.owner.id)
    workspace.associated_datasets.each do |dataset|
        #puts "workspace_id = #{workspace.id}"
        ChorusObject.create(:chorus_class_id => dataset_class.id, :instance_id => dataset.id, :owner_id => workspace.owner.id, :parent_id => workspace.id)
    end
    workspace.workfiles.each do |workfile|
        #puts "workspace_id = #{workspace.id}, workfile_id = #{workfile.id}"
        ChorusObject.create(:chorus_class_id => workfile_class.id, :instance_id => workfile.id, :owner_id => workspace.owner.id, :parent_id => workspace.id)
        workfile.activities.each do |activity|
            c = ChorusObject.create(:chorus_class_id => activity_class.id, :instance_id  => activity.id, :owner_id => workspace.owner.id, :parent_id => workfile.id)
            puts "c.owner_id = #{c.owner_id}  c.parent_id = #{c.parent_id}"
        end
        workfile.comments.each do |comment|
            ChorusObject.create(:chorus_class_id => comment_class.id, :instance_id => comment.id, :owner_id => workfile.owner.id, :parent_id => workfile.id)
        end
    end
    workspace.activities.each do |activity|
        c = ChorusObject.create(:chorus_class_id => activity_class.id, :instance_id => activity.id, :owner_id => workspace.owner.id, :parent_id => workspace.id)
        puts "c.owner_id = #{c.owner_id}  c.parent_id = #{c.parent_id}"
    end
    workspace.jobs.each do |job|
        ChorusObject.create(:chorus_class_id => job_class.id, :instance_id => job.id, :owner_id => workspace.owner.id, :parent_id => workspace.id)
    end
    workspace.milestones.each do |milestone|
        ChorusObject.create(:chorus_class_id => milestone_class.id, :instance_id => milestone.id, :owner_id => workspace.owner.id, :parent_id => workspace.id)
    end
    workspace.tags.each do |tag|
        ChorusObject.create(:chorus_class_id => tag_class.id, :instance_id => tag.id, :owner_id => workspace.owner.id, :parent_id => workspace.id)
    end
    workspace.members.each do |member|
        ChorusObject.create(:chorus_class_id => membership_class.id, :instance_id => member.id, :owner_id => workspace.owner.id, :parent_id => workspace.id)
    end
    workspace.comments.each do |comment|
        ChorusObject.create(:chorus_class_id => comment_class.id, :instance_id => comment.id, :owner_id => workspace.owner.id, :parent_id => workspace.id)
    end
end


DataSource.all.each do |data_source|
    ChorusObject.create(:chorus_class_id => data_source_class.id, :instance_id => data_source.id, :owner_id => data_source.owner.id)
end

#for testing only
scope_A = Scope.create(:name => 'scope_A')
scope_B = Scope.create(:name => 'scope_B')

#for testing only
group_A = Group.create(:name => 'group_A')
group_B = Group.create(:name => 'group_B')

group_A.scope = scope_A
group_A.save!
group_B.scope = scope_B
group_B.save!

i = 0

Workspace.all.each do |workspace|
    instance = ChorusObject.find_by_instance_id(workspace.id)
    if i.odd?
        instance.scope = scope_A
    else
      instance.scope = scope_B
    end
    i = i + 1
end

i = 0

DataSource.all.each do |data_source|
    instance = ChorusObject.find_by_instance_id(data_source.id)
    if i.odd?
        instance.scope = scope_A
    else
        instance.scope = scope_B
    end
    i = i + 1
end
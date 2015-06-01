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
        {:name => 'activity'.camelize},
        {:name => 'alpine_workfile'.camelize},
        {:name => 'associated_dataset'.camelize},
        {:name => 'chorus_view'.camelize},
        {:name => 'chorus_workfile'.camelize},
        {:name => 'comment'.camelize},
        {:name => 'csv_file'.camelize},
        {:name => 'csv_import'.camelize},
        {:name => 'dashboard'.camelize},
        {:name => 'dashboard_config'.camelize},
        {:name => 'dashboard_item'.camelize},
        {:name => 'data_source'.camelize},
        {:name => 'data_source_account'.camelize},
        {:name => 'database'.camelize},
        {:name => 'dataset'.camelize},
        {:name => 'database_column'.camelize},
        {:name => 'datasets_note'.camelize},
        {:name => 'external_table'.camelize},
        {:name => 'gnip_data_source'.camelize},
        {:name => 'gnip_import'.camelize},
        {:name => 'gpdb_column_statistics'.camelize},
        {:name => 'gpdb_data_source'.camelize},
        {:name => 'gpdb_database'.camelize},
        {:name => 'gpdb_dataset_column'.camelize},
        {:name => 'gpdb_schena'.camelize},
        {:name => 'gpdb_table'.camelize},
        {:name => 'gpdb_view'.camelize},
        {:name => 'greenplum_sql_result'.camelize},
        {:name => 'group'.camelize},
        {:name => 'hdfs_data_source'.camelize},
        {:name => 'hdfs_dataset'.camelize},
        {:name => 'hdfs_dataset_statistics'.camelize},
        {:name => 'hdfs_entry'.camelize},
        {:name => 'hdfs_entry_statistics'.camelize},
        {:name => 'hdfs_file'.camelize},
        {:name => 'hdfs_import'.camelize},
        {:name => 'insight'.camelize},
        {:name => 'import'.camelize},
        {:name => 'import_source_data_task'.camelize},
        {:name => 'import_source_task_result'.camelize},
        {:name => 'imoort_template'.camelize},
        {:name => 'jdbc_data_source'.camelize},
        {:name => 'jdbc_dataset'.camelize},
        {:name => 'jdbc_dataset_column'.camelize},
        {:name => 'jdbc_hive_data_source'.camelize},
        {:name => 'jdbc_schema'.camelize},
        {:name => 'jdbc_sql_result'.camelize},
        {:name => 'jdbc_table'.camelize},
        {:name => 'jdbc_view'.camelize},
        {:name => 'job'.camelize},
        {:name => 'job_result'.camelize},
        {:name => 'job_task'.camelize},
        {:name => 'job_task_result'.camelize},
        {:name => 'ldap_config'.camelize},
        {:name => 'license'.camelize},
        {:name => 'linked_tableau_workfile'.camelize},
        {:name => 'membership'.camelize},
        {:name => 'milestone'.camelize},
        {:name => 'my_workspace_search'.camelize},
        {:name => 'note'.camelize},
        {:name => 'notes_workflow_result'.camelize},
        {:name => 'notes_workfile'.camelize},
        {:name => 'notification'.camelize},
        {:name => 'open_worlfile_event'.camelize},
        {:name => 'operation'.camelize},
        {:name => 'oracle_data_source'.camelize},
        {:name => 'oracle_dataset'.camelize},
        {:name => 'oracle_dataset_column'.camelize},
        {:name => 'oracle_schema'.camelize},
        {:name => 'oracle_sql_result'.camelize},
        {:name => 'oracle_table'.camelize},
        {:name => 'oracle_view'.camelize},
        {:name => 'permission'.camelize},
        {:name => 'pg_data_source'.camelize},
        {:name => 'pg_database'.camelize},
        {:name => 'pg_dataset'.camelize},
        {:name => 'pg_dataset_column'.camelize},
        {:name => 'pg_schema'.camelize},
        {:name => 'pg_table'.camelize},
        {:name => 'pg_view'.camelize},
        {:name => 'relational_dataset'.camelize},
        {:name => 'role'.camelize},
        {:name => 'run_sql_workfile_task'.camelize},
        {:name => 'run_workflow_task'.camelize},
        {:name => 'run_workflow_task_result'.camelize},
        {:name => 'sandbox'.camelize},
        {:name => 'schema'.camelize},
        {:name => 'schema_function'.camelize},
        {:name => 'schema_import'.camelize},
        {:name => 'scope'.camelize},
        {:name => 'search'.camelize},
        {:name => 'session'.camelize},
        {:name => 'sql_result'.camelize},
        {:name => 'sql_value_parser'.camelize},
        {:name => 'system_status'.camelize},
        {:name => 'tableau_publisher'.camelize},
        {:name => 'tableau_workbook_publication'.camelize},
        {:name => 'tag'.camelize},
        {:name => 'tagging'.camelize},
        {:name => 'type_ahead_search'.camelize},
        {:name => 'upload'.camelize},
        {:name => 'user'.camelize},
        {:name => 'visualization'.camelize},
        {:name => 'workfile'.camelize},
        {:name => 'workfile_draft'.camelize},
        {:name => 'workfile_execution_location'.camelize},
        {:name => 'workfile_version'.camelize},
        {:name => 'workspace'.camelize},
        {:name => 'workspace_import'.camelize},
        {:name => 'workspace_search'.camelize},
    ]
)


#models/dashboard

ChorusClass.create(
    [
        {:name => 'recent_workfiles'.camelize},
        {:name => 'site_snapshot'.camelize},
        {:name => 'workspace_activity'.camelize}

    ]
)

#models/events

ChorusClass.create(
    [
        {:name => 'base'.camelize},
        {:name => 'chorus_view_changed'.camelize},
        {:name => 'chorus_view_created'.camelize},
        {:name => 'credentials_invalid'.camelize},
        {:name => 'data_source_changed_name'.camelize},
        {:name => 'data_source_changed_owner'.camelize},
        {:name => 'data_source_created'.camelize},
        {:name => 'data_source_deleted'.camelize},
        {:name => 'file_import_created'.camelize},
        {:name => 'file_import_failed'.camelize},

    # TBD. Can these event types be handle in better way?

    ]
)

#model/visualization

ChorusClass.create(
    [
        {:name => 'boxplot'.camelize},
        {:name => 'frequency'.camelize},
        {:name => 'heatmap'.camelize},
        {:name => 'histograp'.camelize},
        {:name => 'timeseries'.camelize}

    ]
)

workspace_class = ChorusClass.where(:name => 'workspace'.camelize).first
data_source_class = ChorusClass.where(:name => 'data_source'.camelize).first
database_class = ChorusClass.where(:name => 'database'.camelize).first
job_class  = ChorusClass.where(:name => 'job'.camelize).first
milestone_class = ChorusClass.where(:name => 'milestone'.camelize).first
membership_class = ChorusClass.where(:name => 'membership'.camelize).first
workfile_class = ChorusClass.where(:name => 'workfile'.camelize).first
activity_class = ChorusClass.where(:name => 'activity'.camelize).first
event_class = ChorusClass.where(:name => 'base'.camelize).first
note_class = ChorusClass.where(:name => 'note'.camelize).first
comment_class = ChorusClass.where(:name => 'comment'.camelize).first
chorus_view_class = ChorusClass.where(:name => 'chorus_view'.camelize).first
sandbox_class = ChorusClass.where(:name => 'sandbox'.camelize).first
csv_file_class = ChorusClass.where(:name => 'csv_file'.camelize).first
dataset_class = ChorusClass.where(:name => 'dataset'.camelize).first
associated_dataset_class = ChorusClass.where(:name => 'associated_dataset'.camelize).first
import_class = ChorusClass.where(:name => 'import'.camelize).first
tag_class = ChorusClass.where(:name => 'tag'.camelize).first

job_class.update_attributes({:parent_class_name => 'workspace'.camelize}, {:parent_class_id => workspace_class.id} )
milestone_class.update_attributes({:parent_class_name => 'workspace'.camelize}, {:parent_class_id => workspace_class.id} )
membership_class.update_attributes({:parent_class_name => 'workspace'.camelize}, {:parent_class_id => workspace_class.id} )
workfile_class.update_attributes({:parent_class_name => 'workspace'.camelize}, {:parent_class_id => workspace_class.id} )
activity_class.update_attributes({:parent_class_name => 'workspace'.camelize}, {:parent_class_id => workspace_class.id} )
event_class.update_attributes({:parent_class_name => 'workspace'.camelize}, {:parent_class_id => workspace_class.id} )
note_class.update_attributes({:parent_class_name => 'workspace'.camelize}, {:parent_class_id => workspace_class.id} )
comment_class.update_attributes({:parent_class_name => 'workspace'.camelize}, {:parent_class_id => workspace_class.id} )
chorus_view_class.update_attributes({:parent_class_name => 'workspace'.camelize}, {:parent_class_id => workspace_class.id} )
sandbox_class.update_attributes({:parent_class_name => 'workspace'.camelize}, {:parent_class_id => workspace_class.id} )
csv_file_class.update_attributes({:parent_class_name => 'workspace'.camelize}, {:parent_class_id => workspace_class.id} )
dataset_class.update_attributes({:parent_class_name => 'workspace'.camelize}, {:parent_class_id => workspace_class.id} )
associated_dataset_class.update_attributes({:parent_class_name => 'workspace'.camelize}, {:parent_class_id => workspace_class.id} )
import_class.update_attributes({:parent_class_name => 'workspace'.camelize}, {:parent_class_id => workspace_class.id} )


puts '---- Adding Chorus objects  ----'

Workspace.all.each do |workspace|
    ChorusObject.create(:chorus_class_id => workspace_class.id, :instance_id => workspace.id, :owner_id => workspace.owner.id)
    workspace.associated_datasets.each do |dataset|
        #puts "workspace_id = #{workspace.id}"
        ChorusObject.create(:chorus_class_id => dataset_class.id, :instance_id => dataset.id, :owner_id => workspace.owner.id, :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id)
    end
    workspace.workfiles.each do |workfile|
        #puts "workspace_id = #{workspace.id}, workfile_id = #{workfile.id}"
        ChorusObject.create(:chorus_class_id => workfile_class.id, :instance_id => workfile.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id)
        workfile.activities.each do |activity|
            c = ChorusObject.create(:chorus_class_id => activity_class.id, :instance_id  => activity.id, :owner_id => workspace.owner.id,  :parent_class_name => workfile.class.name, :parent_class_id => ChorusClass.find_by_name(workfile.class.name).id, :parent_id => workfile.id)
            #puts "c.owner_id = #{c.owner_id}  c.parent_id = #{c.parent_id}"
        end
        workfile.comments.each do |comment|
            ChorusObject.create(:chorus_class_id => comment_class.id, :instance_id => comment.id, :owner_id => workfile.owner.id,  :parent_class_name => workfile.class.name, :parent_class_id => ChorusClass.find_by_name(workfile.class.name).id, :parent_id => workfile.id)
        end
    end
    workspace.activities.each do |activity|
        c = ChorusObject.create(:chorus_class_id => activity_class.id, :instance_id => activity.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id)
        #puts "c.owner_id = #{c.owner_id}  c.parent_id = #{c.parent_id}"
    end
    workspace.jobs.each do |job|
        ChorusObject.create(:chorus_class_id => job_class.id, :instance_id => job.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id)
    end
    workspace.milestones.each do |milestone|
        ChorusObject.create(:chorus_class_id => milestone_class.id, :instance_id => milestone.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id)
    end
    workspace.tags.each do |tag|
        ChorusObject.create(:chorus_class_id => tag_class.id, :instance_id => tag.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id)
    end
    workspace.members.each do |member|
        ChorusObject.create(:chorus_class_id => membership_class.id, :instance_id => member.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id)
    end
    workspace.comments.each do |comment|
        ChorusObject.create(:chorus_class_id => comment_class.id, :instance_id => comment.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id)
    end
end


DataSource.all.each do |data_source|
    ChorusObject.create(:chorus_class_id => data_source_class.id, :instance_id => data_source.id, :owner_id => data_source.owner.id)
end

puts "============== FOLLOWING IS FOR TESTING PURPOSR ONLY ================="
puts ''
puts '--- Adding scopes ----'
#for testing only
scope_A = Scope.create(:name => 'scope_A')
scope_B = Scope.create(:name => 'scope_B')

puts ''
puts '---- Adding groups ----'
#for testing only
group_A = Group.create(:name => 'group_A')
group_B = Group.create(:name => 'group_B')

puts ''
puts '---- Assiging scopes to groups ----'
group_A.scope = scope_A
group_A.save!
group_B.scope = scope_B
group_B.save!

puts ''
puts '---- Randomlu assigning workspace and data sources  to scopes ----'
i = 0

Workspace.all.each do |workspace|
    instance = ChorusObject.find_by_instance_id(workspace.id)
    if i.odd?
        instance.scope = scope_A
        puts "adding #{instance.id} to scope A"
        instance.save!
    else
      instance.scope = scope_B
      puts "adding #{instance.id} to scope B"
      instance.save!
    end
    i = i + 1
end

i = 0

DataSource.all.each do |data_source|
    instance = ChorusObject.find_by_instance_id(data_source.id)
    if i.odd?
        instance.scope = scope_A
        instance.save!
    else
        instance.scope = scope_B
        instance.save!
    end
    i = i + 1
end
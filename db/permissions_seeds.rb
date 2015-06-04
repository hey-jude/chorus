# Seed roles groups and permissions
# roles
puts ''
puts '---- Adding Roles ----'
admin_role = Role.create(:name => 'admin'.camelize)
owner_role = Role.create(:name => 'owner'.camelize)
developer_role = Role.create(:name => 'developer'.camelize)
collaborator_role = Role.create(:name => 'collaborator'.camelize)
site_admin_role = Role.create(:name => 'site_administrator'.camelize)
app_admin_role = Role.create(:name => 'application_administrator'.camelize)
app_manager_role = Role.create(:name => 'application_manager'.camelize)
workflow_developer_role = Role.create(:name => 'workflow_developer_manager'.camelize)
project_manager_role = Role.create(:name => 'project_manager'.camelize)
project_developer_role = Role.create(:name => 'project_developer'.camelize)
contributor_role = Role.create(:name => 'contributor'.camelize)
data_scientist_role = Role.create(:name => 'data_scientist'.camelize)

puts ''
puts '---- Adding permissions ----'


chorusadmin = User.find_by_username("chorusadmin")

admin_role.users << chorusadmin


# Groups
puts '---- Adding Default Group  ----'
default_group = Group.create(:name => 'default_group')
Role.all.each do |role|
    role.groups << default_group
end

# Scope
puts ''
puts '---- Adding Default Scope ----'
default_scope = ChorusScope.create(:name => 'default_scope')

# permissions
# User.set_permissions_for [admin_role], [:create, :destroy, :ldap, :update]
# Events::Note.set_permissions_for [admin_role], [:destroy, :demote_from_insight, :update]
# Workspace.set_permissions_for [admin_role], [:show, :update, :destroy, :admin]
# Workspace.set_permissions_for [developer_role], [:show, :update, :create_workflow]
# DataSource.set_permissions_for [admin_role], [:edit]

puts ''
puts '---- Adding Chorus object classes  ----'
ChorusClass.create(
    [
        {:name => 'activity'.camelize},
        {:name => 'account'.camelize},
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
        {:name => 'task'.camelize},
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
user_class = ChorusClass.where(:name => 'user'.camelize).first
account_class = ChorusClass.where(:name => 'account'.camelize).first
datasource_class = ChorusClass.where(:name => 'data_source'.camelize).first
group_class = ChorusClass.where(:name => 'group'.camelize).first
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
schema_class = ChorusClass.where(:name => 'schema'.camelize).first
task_class = ChorusClass.where(:name => 'task'.camelize).first
insight_class = ChorusClass.where(:name => 'insight'.camelize).first

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

puts ''
puts '---- Adding Operations ----'

order = 1
%w(show update destroy create  change_password edit_dashboard manage_notifications manage_comments manage_notes manage_insights manage_data_source_credentials).each do |operation|
    user_class.operations << Operation.create(:name => operation, :sequence => order)
    order = order + 1
end

order = 1
%w(create read view update delete change_password lock unlock).each do |operation|
    account_class.operations << Operation.create(:name => operation, :sequence => order)
    order = order + 1
end

order = 1
%w(show update destroy create).each do |operation|
    group_class.operations << Operation.create(:name => operation, :sequence => order)
    order = order + 1
end

order = 1
%w(show update destroy admin create_workflow create edit_settings add_members delete_members add_to_scope remove_from_scope add_sandbox delete_sandbox change_status add_data remove_data explore_data transform_data download_data).each do |operation|
    workspace_class.operations << Operation.create(:name => operation, :sequence => order)
    order = order + 1
end

order = 1
%w(show update destroy create  add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data).each do |operation|
    datasource_class.operations << Operation.create(:name => operation, :sequence => order)
    order = order + 1

end

order = 1
%w(show update destroy create).each do |operation|
    note_class.operations << Operation.create(:name => operation, :sequence => order)
    order = order + 1
end

order = 1
%w(show update destroy create).each do |operation|
    schema_class.operations << Operation.create(:name => operation, :sequence => order)
    order = order + 1
end

order = 1
%w(show update destroy create add_to_workspace delete_from_workspace).each do |operation|
    sandbox_class.operations << Operation.create(:name => operation, :sequence => order)
    order = order + 1
end

order = 1
%w(show update destroy  create  promote_to_insight).each do |operation|
    comment_class.operations << Operation.create(:name => operation, :sequence => order)
    order = order + 1
end

order = 1
%w(show update destroy create  promote demote publish unpublish).each do |operation|
    insight_class.operations << Operation.create(:name => operation, :sequence => order)
    order = order + 1
end

order = 1
%w(show update destroy create  run_workflow ).each do |operation|
    workfile_class.operations << Operation.create(:name => operation, :sequence => order)
    order = order + 1
end

order = 1
%w(show update destroy  create run stop).each do |operation|
    job_class.operations << Operation.create(:name => operation, :sequence => order)
    order = order + 1
end

order = 1
%w(show update destroy create run stop).each do |operation|
    task_class.operations << Operation.create(:name => operation, :sequence => order)
    order = order + 1
end

order = 1
%w(show update destroy create complete restart).each do |operation|
    milestone_class.operations << Operation.create(:name => operation, :sequence => order)
    order = order + 1
end

order = 1
%w(show update destroy create apply remove).each do |operation|
    tag_class.operations << Operation.create(:name => operation, :sequence => order)
    order = order + 1
end

puts ''
puts '=================== Adding permissions to Roles ======================'

# Given an array of permission symbols, this function
# returns an integer with the proper permission bits set
def create_permission_mask_for(permissions, operations)
    bits = 0
    return bits if permissions.nil?

    permissions.each do |permission|
        index = operations.index(permission.to_sym)
        puts "#{permission} operation not found" if index.nil?
        bits |= ( 1 << index )
    end

    return bits
end

puts  ''
puts '---- Adding permissions for admin role ----'
user_permissions = %w(show update destroy create  change_password edit_dashboard manage_notifications manage_comments manage_notes manage_insights manage_data_source_credentials)
account_permissions = %w(create read view update delete change_password lock unlock)
group_permissions = %w(show update destroy create)
workspace_permissions = %w(show update destroy admin  create edit_settings add_members delete_members add_to_scope remove_from_scope  change_status explore_data transform_data download_data)
datasource_permissions = %w(show update destroy create  add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data)
note_permissions = %w(show update destroy create)
schema_permissions = %w(show update destroy create)
sandbox_permissions = %w(show update destroy create add_to_workspace delete_from_workspace)
comment_permissions = %w(show update destroy  create  promote_to_insight)
insight_permissions = %w(show update destroy create  promote demote publish unpublish)
workfile_permissions = %w(show update destroy create  run_workflow )
job_permissions = %w(show update destroy  create run stop)
task_permissions = %w(show update destroy create run stop)
milestome_permissions = %w(show update destroy create complete restart)
tag_permissions = %w(show update destroy create apply remove)

admin_role.permissions << Permission.create(:role_id => admin_role.id, :chorus_class_id => user_class.id, :permissions_mask => create_permission_mask_for(user_permissions, user_class.class_operations))
admin_role.permissions << Permission.create(:role_id => admin_role.id, :chorus_class_id => account_class.id, :permissions_mask => create_permission_mask_for(account_permissions, account_class.class_operations))
admin_role.permissions << Permission.create(:role_id => admin_role.id, :chorus_class_id => group_class.id, :permissions_mask => create_permission_mask_for(group_permissions, group_class.class_operations))
admin_role.permissions << Permission.create(:role_id => admin_role.id, :chorus_class_id => workspace_class.id, :permissions_mask => create_permission_mask_for(workspace_permissions, workspace_class.class_operations))
admin_role.permissions << Permission.create(:role_id => admin_role.id, :chorus_class_id => datasource_class.id, :permissions_mask => create_permission_mask_for(datasource_permissions, datasource_class.class_operations))
admin_role.permissions << Permission.create(:role_id => admin_role.id, :chorus_class_id => note_class.id, :permissions_mask => create_permission_mask_for(note_permissions, note_class.class_operations))
admin_role.permissions << Permission.create(:role_id => admin_role.id, :chorus_class_id => schema_class.id, :permissions_mask => create_permission_mask_for(schema_permissions, schema_class.class_operations))
admin_role.permissions << Permission.create(:role_id => admin_role.id, :chorus_class_id => sandbox_class.id, :permissions_mask => create_permission_mask_for(sandbox_permissions, sandbox_class.class_operations))
admin_role.permissions << Permission.create(:role_id => admin_role.id, :chorus_class_id => comment_class.id, :permissions_mask => create_permission_mask_for(comment_permissions, comment_class.class_operations))
admin_role.permissions << Permission.create(:role_id => admin_role.id, :chorus_class_id => insight_class.id, :permissions_mask => create_permission_mask_for(insight_permissions, insight_class.class_operations))
admin_role.permissions << Permission.create(:role_id => admin_role.id, :chorus_class_id => workfile_class.id, :permissions_mask => create_permission_mask_for(workfile_permissions, workfile_class.class_operations))
admin_role.permissions << Permission.create(:role_id => admin_role.id, :chorus_class_id => job_class.id, :permissions_mask => create_permission_mask_for(job_permissions, job_class.class_operations))
admin_role.permissions << Permission.create(:role_id => admin_role.id, :chorus_class_id => task_class.id, :permissions_mask => create_permission_mask_for(task_permissions, task_class.class_operations))
admin_role.permissions << Permission.create(:role_id => admin_role.id, :chorus_class_id => milestone_class.id, :permissions_mask => create_permission_mask_for(milestome_permissions, milestone_class.class_operations))
admin_role.permissions << Permission.create(:role_id => admin_role.id, :chorus_class_id => tag_class.id, :permissions_mask => create_permission_mask_for(tag_permissions, tag_class.class_operations))

puts ''
puts '---- Adding permissions for owner role ----'
user_permissions = %w(show change_password edit_dashboard manage_notifications manage_comments manage_notes manage_insights manage_data_source_credentials)
account_permissions = %w(create read view update delete change_password lock unlock)
group_permissions = %w(show update destroy create)
workspace_permissions = %w(show update destroy admin  create edit_settings add_members delete_members add_to_scope remove_from_scope  change_status explore_data transform_data download_data)
datasource_permissions = %w(show update destroy create  add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data)
note_permissions = %w(show update destroy create)
schema_permissions = %w(show update destroy create)
sandbox_permissions = %w(show update destroy create add_to_workspace delete_from_workspace)
comment_permissions = %w(show update destroy  create  promote_to_insight)
insight_permissions = %w(show update destroy create  promote demote publish unpublish)
workfile_permissions = %w(show update destroy create  run_workflow )
job_permissions = %w(show update destroy  create run stop)
task_permissions = %w(show update destroy create run stop)
milestome_permissions = %w(show update destroy create complete restart)
tag_permissions = %w(show update destroy create apply remove)

owner_role.permissions << Permission.create(:role_id => owner_role.id, :chorus_class_id => user_class.id, :permissions_mask => create_permission_mask_for(user_permissions, user_class.class_operations))
owner_role.permissions << Permission.create(:role_id => owner_role.id, :chorus_class_id => account_class.id, :permissions_mask => create_permission_mask_for(account_permissions, account_class.class_operations))
owner_role.permissions << Permission.create(:role_id => owner_role.id, :chorus_class_id => group_class.id, :permissions_mask => create_permission_mask_for(group_permissions, group_class.class_operations))
owner_role.permissions << Permission.create(:role_id => owner_role.id, :chorus_class_id => workspace_class.id, :permissions_mask => create_permission_mask_for(workspace_permissions, workspace_class.class_operations))
owner_role.permissions << Permission.create(:role_id => owner_role.id, :chorus_class_id => datasource_class.id, :permissions_mask => create_permission_mask_for(datasource_permissions, datasource_class.class_operations))
owner_role.permissions << Permission.create(:role_id => owner_role.id, :chorus_class_id => note_class.id, :permissions_mask => create_permission_mask_for(note_permissions, note_class.class_operations))
owner_role.permissions << Permission.create(:role_id => owner_role.id, :chorus_class_id => schema_class.id, :permissions_mask => create_permission_mask_for(schema_permissions, schema_class.class_operations))
owner_role.permissions << Permission.create(:role_id => owner_role.id, :chorus_class_id => sandbox_class.id, :permissions_mask => create_permission_mask_for(sandbox_permissions, sandbox_class.class_operations))
owner_role.permissions << Permission.create(:role_id => owner_role.id, :chorus_class_id => comment_class.id, :permissions_mask => create_permission_mask_for(comment_permissions, comment_class.class_operations))
owner_role.permissions << Permission.create(:role_id => owner_role.id, :chorus_class_id => insight_class.id, :permissions_mask => create_permission_mask_for(insight_permissions, insight_class.class_operations))
owner_role.permissions << Permission.create(:role_id => owner_role.id, :chorus_class_id => workfile_class.id, :permissions_mask => create_permission_mask_for(workfile_permissions, workfile_class.class_operations))
owner_role.permissions << Permission.create(:role_id => owner_role.id, :chorus_class_id => job_class.id, :permissions_mask => create_permission_mask_for(job_permissions, job_class.class_operations))
owner_role.permissions << Permission.create(:role_id => owner_role.id, :chorus_class_id => task_class.id, :permissions_mask => create_permission_mask_for(task_permissions, task_class.class_operations))
owner_role.permissions << Permission.create(:role_id => owner_role.id, :chorus_class_id => milestone_class.id, :permissions_mask => create_permission_mask_for(milestome_permissions, milestone_class.class_operations))
owner_role.permissions << Permission.create(:role_id => owner_role.id, :chorus_class_id => tag_class.id, :permissions_mask => create_permission_mask_for(tag_permissions, tag_class.class_operations))


puts ''
puts '---- Adding permissions for developer role ----'
user_permissions = %w(show update destroy create  change_password edit_dashboard manage_notifications manage_comments manage_notes manage_insights manage_data_source_credentials)
account_permissions = %w(create read view update delete change_password lock unlock)
group_permissions = %w(show update destroy create)
workspace_permissions = %w(show update destroy admin  create edit_settings add_members delete_members add_to_scope remove_from_scope  change_status explore_data transform_data download_data)
datasource_permissions = %w(show update destroy create  add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data)
note_permissions = %w(show update destroy create)
schema_permissions = %w(show update destroy create)
sandbox_permissions = %w(show update destroy create add_to_workspace delete_from_workspace)
comment_permissions = %w(show update destroy  create  promote_to_insight)
insight_permissions = %w(show update destroy create  promote demote publish unpublish)
workfile_permissions = %w(show update destroy create  run_workflow )
job_permissions = %w(show update destroy  create run stop)
task_permissions = %w(show update destroy create run stop)
milestome_permissions = %w(show update destroy create complete restart)
tag_permissions = %w(show update destroy create apply remove)

developer_role.permissions << Permission.create(:role_id => developer_role.id, :chorus_class_id => user_class.id, :permissions_mask => create_permission_mask_for(user_permissions, user_class.class_operations))
developer_role.permissions << Permission.create(:role_id => developer_role.id, :chorus_class_id => account_class.id, :permissions_mask => create_permission_mask_for(account_permissions, account_class.class_operations))
developer_role.permissions << Permission.create(:role_id => developer_role.id, :chorus_class_id => group_class.id, :permissions_mask => create_permission_mask_for(group_permissions, group_class.class_operations))
developer_role.permissions << Permission.create(:role_id => developer_role.id, :chorus_class_id => workspace_class.id, :permissions_mask => create_permission_mask_for(workspace_permissions, workspace_class.class_operations))
developer_role.permissions << Permission.create(:role_id => developer_role.id, :chorus_class_id => datasource_class.id, :permissions_mask => create_permission_mask_for(datasource_permissions, datasource_class.class_operations))
developer_role.permissions << Permission.create(:role_id => developer_role.id, :chorus_class_id => note_class.id, :permissions_mask => create_permission_mask_for(note_permissions, note_class.class_operations))
developer_role.permissions << Permission.create(:role_id => developer_role.id, :chorus_class_id => schema_class.id, :permissions_mask => create_permission_mask_for(schema_permissions, schema_class.class_operations))
developer_role.permissions << Permission.create(:role_id => developer_role.id, :chorus_class_id => sandbox_class.id, :permissions_mask => create_permission_mask_for(sandbox_permissions, sandbox_class.class_operations))
developer_role.permissions << Permission.create(:role_id => developer_role.id, :chorus_class_id => comment_class.id, :permissions_mask => create_permission_mask_for(comment_permissions, comment_class.class_operations))
developer_role.permissions << Permission.create(:role_id => developer_role.id, :chorus_class_id => insight_class.id, :permissions_mask => create_permission_mask_for(insight_permissions, insight_class.class_operations))
developer_role.permissions << Permission.create(:role_id => developer_role.id, :chorus_class_id => workfile_class.id, :permissions_mask => create_permission_mask_for(workfile_permissions, workfile_class.class_operations))
developer_role.permissions << Permission.create(:role_id => developer_role.id, :chorus_class_id => job_class.id, :permissions_mask => create_permission_mask_for(job_permissions, job_class.class_operations))
developer_role.permissions << Permission.create(:role_id => developer_role.id, :chorus_class_id => task_class.id, :permissions_mask => create_permission_mask_for(task_permissions, task_class.class_operations))
developer_role.permissions << Permission.create(:role_id => developer_role.id, :chorus_class_id => milestone_class.id, :permissions_mask => create_permission_mask_for(milestome_permissions, milestone_class.class_operations))
developer_role.permissions << Permission.create(:role_id => developer_role.id, :chorus_class_id => tag_class.id, :permissions_mask => create_permission_mask_for(tag_permissions, tag_class.class_operations))



puts ''
puts '---- Adding permissions for collborator role ----'
user_permissions = %w(show update destroy create  change_password edit_dashboard manage_notifications manage_comments manage_notes manage_insights manage_data_source_credentials)
account_permissions = %w(create read view update delete change_password lock unlock)
group_permissions = %w(show update destroy create)
workspace_permissions = %w(show update destroy admin  create edit_settings add_members delete_members add_to_scope remove_from_scope  change_status explore_data transform_data download_data)
datasource_permissions = %w(show update destroy create  add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data)
note_permissions = %w(show update destroy create)
schema_permissions = %w(show update destroy create)
sandbox_permissions = %w(show update destroy create add_to_workspace delete_from_workspace)
comment_permissions = %w(show update destroy  create  promote_to_insight)
insight_permissions = %w(show update destroy create  promote demote publish unpublish)
workfile_permissions = %w(show update destroy create  run_workflow )
job_permissions = %w(show update destroy  create run stop)
task_permissions = %w(show update destroy create run stop)
milestome_permissions = %w(show update destroy create complete restart)
tag_permissions = %w(show update destroy create apply remove)

collaborator_role.permissions << Permission.create(:role_id => collaborator_role.id, :chorus_class_id => user_class.id, :permissions_mask => create_permission_mask_for(user_permissions, user_class.class_operations))
collaborator_role.permissions << Permission.create(:role_id => collaborator_role.id, :chorus_class_id => account_class.id, :permissions_mask => create_permission_mask_for(account_permissions, account_class.class_operations))
collaborator_role.permissions << Permission.create(:role_id => collaborator_role.id, :chorus_class_id => group_class.id, :permissions_mask => create_permission_mask_for(group_permissions, group_class.class_operations))
collaborator_role.permissions << Permission.create(:role_id => collaborator_role.id, :chorus_class_id => workspace_class.id, :permissions_mask => create_permission_mask_for(workspace_permissions, workspace_class.class_operations))
collaborator_role.permissions << Permission.create(:role_id => collaborator_role.id, :chorus_class_id => datasource_class.id, :permissions_mask => create_permission_mask_for(datasource_permissions, datasource_class.class_operations))
collaborator_role.permissions << Permission.create(:role_id => collaborator_role.id, :chorus_class_id => note_class.id, :permissions_mask => create_permission_mask_for(note_permissions, note_class.class_operations))
collaborator_role.permissions << Permission.create(:role_id => collaborator_role.id, :chorus_class_id => schema_class.id, :permissions_mask => create_permission_mask_for(schema_permissions, schema_class.class_operations))
collaborator_role.permissions << Permission.create(:role_id => collaborator_role.id, :chorus_class_id => sandbox_class.id, :permissions_mask => create_permission_mask_for(sandbox_permissions, sandbox_class.class_operations))
collaborator_role.permissions << Permission.create(:role_id => collaborator_role.id, :chorus_class_id => comment_class.id, :permissions_mask => create_permission_mask_for(comment_permissions, comment_class.class_operations))
collaborator_role.permissions << Permission.create(:role_id => collaborator_role.id, :chorus_class_id => insight_class.id, :permissions_mask => create_permission_mask_for(insight_permissions, insight_class.class_operations))
collaborator_role.permissions << Permission.create(:role_id => collaborator_role.id, :chorus_class_id => workfile_class.id, :permissions_mask => create_permission_mask_for(workfile_permissions, workfile_class.class_operations))
collaborator_role.permissions << Permission.create(:role_id => collaborator_role.id, :chorus_class_id => job_class.id, :permissions_mask => create_permission_mask_for(job_permissions, job_class.class_operations))
collaborator_role.permissions << Permission.create(:role_id => collaborator_role.id, :chorus_class_id => task_class.id, :permissions_mask => create_permission_mask_for(task_permissions, task_class.class_operations))
collaborator_role.permissions << Permission.create(:role_id => collaborator_role.id, :chorus_class_id => milestone_class.id, :permissions_mask => create_permission_mask_for(milestome_permissions, milestone_class.class_operations))
collaborator_role.permissions << Permission.create(:role_id => collaborator_role.id, :chorus_class_id => tag_class.id, :permissions_mask => create_permission_mask_for(tag_permissions, tag_class.class_operations))


puts ''
puts '---- Adding permissions for site administrator role ----'
user_permissions = %w(show update destroy create  change_password edit_dashboard manage_notifications manage_comments manage_notes manage_insights manage_data_source_credentials)
account_permissions = %w(create read view update delete change_password lock unlock)
group_permissions = %w(show update destroy create)
workspace_permissions = %w(show update destroy admin  create edit_settings add_members delete_members add_to_scope remove_from_scope  change_status explore_data transform_data download_data)
datasource_permissions = %w(show update destroy create  add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data)
note_permissions = %w(show update destroy create)
schema_permissions = %w(show update destroy create)
sandbox_permissions = %w(show update destroy create add_to_workspace delete_from_workspace)
comment_permissions = %w(show update destroy  create  promote_to_insight)
insight_permissions = %w(show update destroy create  promote demote publish unpublish)
workfile_permissions = %w(show update destroy create  run_workflow )
job_permissions = %w(show update destroy  create run stop)
task_permissions = %w(show update destroy create run stop)
milestome_permissions = %w(show update destroy create complete restart)
tag_permissions = %w(show update destroy create apply remove)

site_admin_role.permissions << Permission.create(:role_id => site_admin_role.id, :chorus_class_id => user_class.id, :permissions_mask => create_permission_mask_for(user_permissions, user_class.class_operations))
site_admin_role.permissions << Permission.create(:role_id => site_admin_role.id, :chorus_class_id => account_class.id, :permissions_mask => create_permission_mask_for(account_permissions, account_class.class_operations))
site_admin_role.permissions << Permission.create(:role_id => site_admin_role.id, :chorus_class_id => group_class.id, :permissions_mask => create_permission_mask_for(group_permissions, group_class.class_operations))
site_admin_role.permissions << Permission.create(:role_id => site_admin_role.id, :chorus_class_id => workspace_class.id, :permissions_mask => create_permission_mask_for(workspace_permissions, workspace_class.class_operations))
site_admin_role.permissions << Permission.create(:role_id => site_admin_role.id, :chorus_class_id => datasource_class.id, :permissions_mask => create_permission_mask_for(datasource_permissions, datasource_class.class_operations))
site_admin_role.permissions << Permission.create(:role_id => site_admin_role.id, :chorus_class_id => note_class.id, :permissions_mask => create_permission_mask_for(note_permissions, note_class.class_operations))
site_admin_role.permissions << Permission.create(:role_id => site_admin_role.id, :chorus_class_id => schema_class.id, :permissions_mask => create_permission_mask_for(schema_permissions, schema_class.class_operations))
site_admin_role.permissions << Permission.create(:role_id => site_admin_role.id, :chorus_class_id => sandbox_class.id, :permissions_mask => create_permission_mask_for(sandbox_permissions, sandbox_class.class_operations))
site_admin_role.permissions << Permission.create(:role_id => site_admin_role.id, :chorus_class_id => comment_class.id, :permissions_mask => create_permission_mask_for(comment_permissions, comment_class.class_operations))
site_admin_role.permissions << Permission.create(:role_id => site_admin_role.id, :chorus_class_id => insight_class.id, :permissions_mask => create_permission_mask_for(insight_permissions, insight_class.class_operations))
site_admin_role.permissions << Permission.create(:role_id => site_admin_role.id, :chorus_class_id => workfile_class.id, :permissions_mask => create_permission_mask_for(workfile_permissions, workfile_class.class_operations))
site_admin_role.permissions << Permission.create(:role_id => site_admin_role.id, :chorus_class_id => job_class.id, :permissions_mask => create_permission_mask_for(job_permissions, job_class.class_operations))
site_admin_role.permissions << Permission.create(:role_id => site_admin_role.id, :chorus_class_id => task_class.id, :permissions_mask => create_permission_mask_for(task_permissions, task_class.class_operations))
site_admin_role.permissions << Permission.create(:role_id => site_admin_role.id, :chorus_class_id => milestone_class.id, :permissions_mask => create_permission_mask_for(milestome_permissions, milestone_class.class_operations))
site_admin_role.permissions << Permission.create(:role_id => site_admin_role.id, :chorus_class_id => tag_class.id, :permissions_mask => create_permission_mask_for(tag_permissions, tag_class.class_operations))



puts ''
puts '---- Adding permissions for application administrator role ----'

user_permissions = %w(show update destroy create  change_password edit_dashboard manage_notifications manage_comments manage_notes manage_insights manage_data_source_credentials)
account_permissions = %w(create read view update delete change_password lock unlock)
group_permissions = %w(show update destroy create)
workspace_permissions = %w(show update destroy admin  create edit_settings add_members delete_members add_to_scope remove_from_scope  change_status explore_data transform_data download_data)
datasource_permissions = %w(show update destroy create  add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data)
note_permissions = %w(show update destroy create)
schema_permissions = %w(show update destroy create)
sandbox_permissions = %w(show update destroy create add_to_workspace delete_from_workspace)
comment_permissions = %w(show update destroy  create  promote_to_insight)
insight_permissions = %w(show update destroy create  promote demote publish unpublish)
workfile_permissions = %w(show update destroy create  run_workflow )
job_permissions = %w(show update destroy  create run stop)
task_permissions = %w(show update destroy create run stop)
milestome_permissions = %w(show update destroy create complete restart)
tag_permissions = %w(show update destroy create apply remove)

app_admin_role.permissions << Permission.create(:role_id => app_admin_role.id, :chorus_class_id => user_class.id, :permissions_mask => create_permission_mask_for(user_permissions, user_class.class_operations))
app_admin_role.permissions << Permission.create(:role_id => app_admin_role.id, :chorus_class_id => account_class.id, :permissions_mask => create_permission_mask_for(account_permissions, account_class.class_operations))
app_admin_role.permissions << Permission.create(:role_id => app_admin_role.id, :chorus_class_id => group_class.id, :permissions_mask => create_permission_mask_for(group_permissions, group_class.class_operations))
app_admin_role.permissions << Permission.create(:role_id => app_admin_role.id, :chorus_class_id => workspace_class.id, :permissions_mask => create_permission_mask_for(workspace_permissions, workspace_class.class_operations))
app_admin_role.permissions << Permission.create(:role_id => app_admin_role.id, :chorus_class_id => datasource_class.id, :permissions_mask => create_permission_mask_for(datasource_permissions, datasource_class.class_operations))
app_admin_role.permissions << Permission.create(:role_id => app_admin_role.id, :chorus_class_id => note_class.id, :permissions_mask => create_permission_mask_for(note_permissions, note_class.class_operations))
app_admin_role.permissions << Permission.create(:role_id => app_admin_role.id, :chorus_class_id => schema_class.id, :permissions_mask => create_permission_mask_for(schema_permissions, schema_class.class_operations))
app_admin_role.permissions << Permission.create(:role_id => app_admin_role.id, :chorus_class_id => sandbox_class.id, :permissions_mask => create_permission_mask_for(sandbox_permissions, sandbox_class.class_operations))
app_admin_role.permissions << Permission.create(:role_id => app_admin_role.id, :chorus_class_id => comment_class.id, :permissions_mask => create_permission_mask_for(comment_permissions, comment_class.class_operations))
app_admin_role.permissions << Permission.create(:role_id => app_admin_role.id, :chorus_class_id => insight_class.id, :permissions_mask => create_permission_mask_for(insight_permissions, insight_class.class_operations))
app_admin_role.permissions << Permission.create(:role_id => app_admin_role.id, :chorus_class_id => workfile_class.id, :permissions_mask => create_permission_mask_for(workfile_permissions, workfile_class.class_operations))
app_admin_role.permissions << Permission.create(:role_id => app_admin_role.id, :chorus_class_id => job_class.id, :permissions_mask => create_permission_mask_for(job_permissions, job_class.class_operations))
app_admin_role.permissions << Permission.create(:role_id => app_admin_role.id, :chorus_class_id => task_class.id, :permissions_mask => create_permission_mask_for(task_permissions, task_class.class_operations))
app_admin_role.permissions << Permission.create(:role_id => app_admin_role.id, :chorus_class_id => milestone_class.id, :permissions_mask => create_permission_mask_for(milestome_permissions, milestone_class.class_operations))
app_admin_role.permissions << Permission.create(:role_id => app_admin_role.id, :chorus_class_id => tag_class.id, :permissions_mask => create_permission_mask_for(tag_permissions, tag_class.class_operations))


puts ''
puts '---- Adding permissions for application manager role ----'

user_permissions = %w(show update destroy create  change_password edit_dashboard manage_notifications manage_comments manage_notes manage_insights manage_data_source_credentials)
account_permissions = %w(create read view update delete change_password lock unlock)
group_permissions = %w(show update destroy create)
workspace_permissions = %w(show update destroy admin  create edit_settings add_members delete_members add_to_scope remove_from_scope  change_status explore_data transform_data download_data)
datasource_permissions = %w(show update destroy create  add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data)
note_permissions = %w(show update destroy create)
schema_permissions = %w(show update destroy create)
sandbox_permissions = %w(show update destroy create add_to_workspace delete_from_workspace)
comment_permissions = %w(show update destroy  create  promote_to_insight)
insight_permissions = %w(show update destroy create  promote demote publish unpublish)
workfile_permissions = %w(show update destroy create  run_workflow )
job_permissions = %w(show update destroy  create run stop)
task_permissions = %w(show update destroy create run stop)
milestome_permissions = %w(show update destroy create complete restart)
tag_permissions = %w(show update destroy create apply remove)

app_manager_role.permissions << Permission.create(:role_id => app_manager_role.id, :chorus_class_id => user_class.id, :permissions_mask => create_permission_mask_for(user_permissions, user_class.class_operations))
app_manager_role.permissions << Permission.create(:role_id => app_manager_role.id, :chorus_class_id => account_class.id, :permissions_mask => create_permission_mask_for(account_permissions, account_class.class_operations))
app_manager_role.permissions << Permission.create(:role_id => app_manager_role.id, :chorus_class_id => group_class.id, :permissions_mask => create_permission_mask_for(group_permissions, group_class.class_operations))
app_manager_role.permissions << Permission.create(:role_id => app_manager_role.id, :chorus_class_id => workspace_class.id, :permissions_mask => create_permission_mask_for(workspace_permissions, workspace_class.class_operations))
app_manager_role.permissions << Permission.create(:role_id => app_manager_role.id, :chorus_class_id => datasource_class.id, :permissions_mask => create_permission_mask_for(datasource_permissions, datasource_class.class_operations))
app_manager_role.permissions << Permission.create(:role_id => app_manager_role.id, :chorus_class_id => note_class.id, :permissions_mask => create_permission_mask_for(note_permissions, note_class.class_operations))
app_manager_role.permissions << Permission.create(:role_id => app_manager_role.id, :chorus_class_id => schema_class.id, :permissions_mask => create_permission_mask_for(schema_permissions, schema_class.class_operations))
app_manager_role.permissions << Permission.create(:role_id => app_manager_role.id, :chorus_class_id => sandbox_class.id, :permissions_mask => create_permission_mask_for(sandbox_permissions, sandbox_class.class_operations))
app_manager_role.permissions << Permission.create(:role_id => app_manager_role.id, :chorus_class_id => comment_class.id, :permissions_mask => create_permission_mask_for(comment_permissions, comment_class.class_operations))
app_manager_role.permissions << Permission.create(:role_id => app_manager_role.id, :chorus_class_id => insight_class.id, :permissions_mask => create_permission_mask_for(insight_permissions, insight_class.class_operations))
app_manager_role.permissions << Permission.create(:role_id => app_manager_role.id, :chorus_class_id => workfile_class.id, :permissions_mask => create_permission_mask_for(workfile_permissions, workfile_class.class_operations))
app_manager_role.permissions << Permission.create(:role_id => app_manager_role.id, :chorus_class_id => job_class.id, :permissions_mask => create_permission_mask_for(job_permissions, job_class.class_operations))
app_manager_role.permissions << Permission.create(:role_id => app_manager_role.id, :chorus_class_id => task_class.id, :permissions_mask => create_permission_mask_for(task_permissions, task_class.class_operations))
app_manager_role.permissions << Permission.create(:role_id => app_manager_role.id, :chorus_class_id => milestone_class.id, :permissions_mask => create_permission_mask_for(milestome_permissions, milestone_class.class_operations))
app_manager_role.permissions << Permission.create(:role_id => app_manager_role.id, :chorus_class_id => tag_class.id, :permissions_mask => create_permission_mask_for(tag_permissions, tag_class.class_operations))


puts ''
puts '---- Adding permissions for workflow developer role ----'

user_permissions = %w(show update destroy create  change_password edit_dashboard manage_notifications manage_comments manage_notes manage_insights manage_data_source_credentials)
account_permissions = %w(create read view update delete change_password lock unlock)
group_permissions = %w(show update destroy create)
workspace_permissions = %w(show update destroy admin  create edit_settings add_members delete_members add_to_scope remove_from_scope  change_status explore_data transform_data download_data)
datasource_permissions = %w(show update destroy create  add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data)
note_permissions = %w(show update destroy create)
schema_permissions = %w(show update destroy create)
sandbox_permissions = %w(show update destroy create add_to_workspace delete_from_workspace)
comment_permissions = %w(show update destroy  create  promote_to_insight)
insight_permissions = %w(show update destroy create  promote demote publish unpublish)
workfile_permissions = %w(show update destroy create  run_workflow )
job_permissions = %w(show update destroy  create run stop)
task_permissions = %w(show update destroy create run stop)
milestome_permissions = %w(show update destroy create complete restart)
tag_permissions = %w(show update destroy create apply remove)

workflow_developer_role.permissions << Permission.create(:role_id => workflow_developer_role.id, :chorus_class_id => user_class.id, :permissions_mask => create_permission_mask_for(user_permissions, user_class.class_operations))
workflow_developer_role.permissions << Permission.create(:role_id => workflow_developer_role.id, :chorus_class_id => account_class.id, :permissions_mask => create_permission_mask_for(account_permissions, account_class.class_operations))
workflow_developer_role.permissions << Permission.create(:role_id => workflow_developer_role.id, :chorus_class_id => group_class.id, :permissions_mask => create_permission_mask_for(group_permissions, group_class.class_operations))
workflow_developer_role.permissions << Permission.create(:role_id => workflow_developer_role.id, :chorus_class_id => workspace_class.id, :permissions_mask => create_permission_mask_for(workspace_permissions, workspace_class.class_operations))
workflow_developer_role.permissions << Permission.create(:role_id => workflow_developer_role.id, :chorus_class_id => datasource_class.id, :permissions_mask => create_permission_mask_for(datasource_permissions, datasource_class.class_operations))
workflow_developer_role.permissions << Permission.create(:role_id => workflow_developer_role.id, :chorus_class_id => note_class.id, :permissions_mask => create_permission_mask_for(note_permissions, note_class.class_operations))
workflow_developer_role.permissions << Permission.create(:role_id => workflow_developer_role.id, :chorus_class_id => schema_class.id, :permissions_mask => create_permission_mask_for(schema_permissions, schema_class.class_operations))
workflow_developer_role.permissions << Permission.create(:role_id => workflow_developer_role.id, :chorus_class_id => sandbox_class.id, :permissions_mask => create_permission_mask_for(sandbox_permissions, sandbox_class.class_operations))
workflow_developer_role.permissions << Permission.create(:role_id => workflow_developer_role.id, :chorus_class_id => comment_class.id, :permissions_mask => create_permission_mask_for(comment_permissions, comment_class.class_operations))
workflow_developer_role.permissions << Permission.create(:role_id => workflow_developer_role.id, :chorus_class_id => insight_class.id, :permissions_mask => create_permission_mask_for(insight_permissions, insight_class.class_operations))
workflow_developer_role.permissions << Permission.create(:role_id => workflow_developer_role.id, :chorus_class_id => workfile_class.id, :permissions_mask => create_permission_mask_for(workfile_permissions, workfile_class.class_operations))
workflow_developer_role.permissions << Permission.create(:role_id => workflow_developer_role.id, :chorus_class_id => job_class.id, :permissions_mask => create_permission_mask_for(job_permissions, job_class.class_operations))
workflow_developer_role.permissions << Permission.create(:role_id => workflow_developer_role.id, :chorus_class_id => task_class.id, :permissions_mask => create_permission_mask_for(task_permissions, task_class.class_operations))
workflow_developer_role.permissions << Permission.create(:role_id => workflow_developer_role.id, :chorus_class_id => milestone_class.id, :permissions_mask => create_permission_mask_for(milestome_permissions, milestone_class.class_operations))
workflow_developer_role.permissions << Permission.create(:role_id => workflow_developer_role.id, :chorus_class_id => tag_class.id, :permissions_mask => create_permission_mask_for(tag_permissions, tag_class.class_operations))

puts ''
puts '---- Adding permissions for project manager role ----'


user_permissions = %w(show update destroy create  change_password edit_dashboard manage_notifications manage_comments manage_notes manage_insights manage_data_source_credentials)
account_permissions = %w(create read view update delete change_password lock unlock)
group_permissions = %w(show update destroy create)
workspace_permissions = %w(show update destroy admin  create edit_settings add_members delete_members add_to_scope remove_from_scope  change_status explore_data transform_data download_data)
datasource_permissions = %w(show update destroy create  add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data)
note_permissions = %w(show update destroy create)
schema_permissions = %w(show update destroy create)
sandbox_permissions = %w(show update destroy create add_to_workspace delete_from_workspace)
comment_permissions = %w(show update destroy  create  promote_to_insight)
insight_permissions = %w(show update destroy create  promote demote publish unpublish)
workfile_permissions = %w(show update destroy create  run_workflow )
job_permissions = %w(show update destroy  create run stop)
task_permissions = %w(show update destroy create run stop)
milestome_permissions = %w(show update destroy create complete restart)
tag_permissions = %w(show update destroy create apply remove)

project_manager_role.permissions << Permission.create(:role_id => project_manager_role.id, :chorus_class_id => user_class.id, :permissions_mask => create_permission_mask_for(user_permissions, user_class.class_operations))
project_manager_role.permissions << Permission.create(:role_id => project_manager_role.id, :chorus_class_id => account_class.id, :permissions_mask => create_permission_mask_for(account_permissions, account_class.class_operations))
project_manager_role.permissions << Permission.create(:role_id => project_manager_role.id, :chorus_class_id => group_class.id, :permissions_mask => create_permission_mask_for(group_permissions, group_class.class_operations))
project_manager_role.permissions << Permission.create(:role_id => project_manager_role.id, :chorus_class_id => workspace_class.id, :permissions_mask => create_permission_mask_for(workspace_permissions, workspace_class.class_operations))
project_manager_role.permissions << Permission.create(:role_id => project_manager_role.id, :chorus_class_id => datasource_class.id, :permissions_mask => create_permission_mask_for(datasource_permissions, datasource_class.class_operations))
project_manager_role.permissions << Permission.create(:role_id => project_manager_role.id, :chorus_class_id => note_class.id, :permissions_mask => create_permission_mask_for(note_permissions, note_class.class_operations))
project_manager_role.permissions << Permission.create(:role_id => project_manager_role.id, :chorus_class_id => schema_class.id, :permissions_mask => create_permission_mask_for(schema_permissions, schema_class.class_operations))
project_manager_role.permissions << Permission.create(:role_id => project_manager_role.id, :chorus_class_id => sandbox_class.id, :permissions_mask => create_permission_mask_for(sandbox_permissions, sandbox_class.class_operations))
project_manager_role.permissions << Permission.create(:role_id => project_manager_role.id, :chorus_class_id => comment_class.id, :permissions_mask => create_permission_mask_for(comment_permissions, comment_class.class_operations))
project_manager_role.permissions << Permission.create(:role_id => project_manager_role.id, :chorus_class_id => insight_class.id, :permissions_mask => create_permission_mask_for(insight_permissions, insight_class.class_operations))
project_manager_role.permissions << Permission.create(:role_id => project_manager_role.id, :chorus_class_id => workfile_class.id, :permissions_mask => create_permission_mask_for(workfile_permissions, workfile_class.class_operations))
project_manager_role.permissions << Permission.create(:role_id => project_manager_role.id, :chorus_class_id => job_class.id, :permissions_mask => create_permission_mask_for(job_permissions, job_class.class_operations))
project_manager_role.permissions << Permission.create(:role_id => project_manager_role.id, :chorus_class_id => task_class.id, :permissions_mask => create_permission_mask_for(task_permissions, task_class.class_operations))
project_manager_role.permissions << Permission.create(:role_id => project_manager_role.id, :chorus_class_id => milestone_class.id, :permissions_mask => create_permission_mask_for(milestome_permissions, milestone_class.class_operations))
project_manager_role.permissions << Permission.create(:role_id => project_manager_role.id, :chorus_class_id => tag_class.id, :permissions_mask => create_permission_mask_for(tag_permissions, tag_class.class_operations))


puts ''
puts '---- Adding permissions for contributor role  ----'

user_permissions = %w(show update destroy create  change_password edit_dashboard manage_notifications manage_comments manage_notes manage_insights manage_data_source_credentials)
account_permissions = %w(create read view update delete change_password lock unlock)
group_permissions = %w(show update destroy create)
workspace_permissions = %w(show update destroy admin  create edit_settings add_members delete_members add_to_scope remove_from_scope  change_status explore_data transform_data download_data)
datasource_permissions = %w(show update destroy create  add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data)
note_permissions = %w(show update destroy create)
schema_permissions = %w(show update destroy create)
sandbox_permissions = %w(show update destroy create add_to_workspace delete_from_workspace)
comment_permissions = %w(show update destroy  create  promote_to_insight)
insight_permissions = %w(show update destroy create  promote demote publish unpublish)
workfile_permissions = %w(show update destroy create  run_workflow )
job_permissions = %w(show update destroy  create run stop)
task_permissions = %w(show update destroy create run stop)
milestome_permissions = %w(show update destroy create complete restart)
tag_permissions = %w(show update destroy create apply remove)

contributor_role.permissions << Permission.create(:role_id => contributor_role.id, :chorus_class_id => user_class.id, :permissions_mask => create_permission_mask_for(user_permissions, user_class.class_operations))
contributor_role.permissions << Permission.create(:role_id => contributor_role.id, :chorus_class_id => account_class.id, :permissions_mask => create_permission_mask_for(account_permissions, account_class.class_operations))
contributor_role.permissions << Permission.create(:role_id => contributor_role.id, :chorus_class_id => group_class.id, :permissions_mask => create_permission_mask_for(group_permissions, group_class.class_operations))
contributor_role.permissions << Permission.create(:role_id => contributor_role.id, :chorus_class_id => workspace_class.id, :permissions_mask => create_permission_mask_for(workspace_permissions, workspace_class.class_operations))
contributor_role.permissions << Permission.create(:role_id => contributor_role.id, :chorus_class_id => datasource_class.id, :permissions_mask => create_permission_mask_for(datasource_permissions, datasource_class.class_operations))
contributor_role.permissions << Permission.create(:role_id => contributor_role.id, :chorus_class_id => note_class.id, :permissions_mask => create_permission_mask_for(note_permissions, note_class.class_operations))
contributor_role.permissions << Permission.create(:role_id => contributor_role.id, :chorus_class_id => schema_class.id, :permissions_mask => create_permission_mask_for(schema_permissions, schema_class.class_operations))
contributor_role.permissions << Permission.create(:role_id => contributor_role.id, :chorus_class_id => sandbox_class.id, :permissions_mask => create_permission_mask_for(sandbox_permissions, sandbox_class.class_operations))
contributor_role.permissions << Permission.create(:role_id => contributor_role.id, :chorus_class_id => comment_class.id, :permissions_mask => create_permission_mask_for(comment_permissions, comment_class.class_operations))
contributor_role.permissions << Permission.create(:role_id => contributor_role.id, :chorus_class_id => insight_class.id, :permissions_mask => create_permission_mask_for(insight_permissions, insight_class.class_operations))
contributor_role.permissions << Permission.create(:role_id => contributor_role.id, :chorus_class_id => workfile_class.id, :permissions_mask => create_permission_mask_for(workfile_permissions, workfile_class.class_operations))
contributor_role.permissions << Permission.create(:role_id => contributor_role.id, :chorus_class_id => job_class.id, :permissions_mask => create_permission_mask_for(job_permissions, job_class.class_operations))
contributor_role.permissions << Permission.create(:role_id => contributor_role.id, :chorus_class_id => task_class.id, :permissions_mask => create_permission_mask_for(task_permissions, task_class.class_operations))
contributor_role.permissions << Permission.create(:role_id => contributor_role.id, :chorus_class_id => milestone_class.id, :permissions_mask => create_permission_mask_for(milestome_permissions, milestone_class.class_operations))
contributor_role.permissions << Permission.create(:role_id => contributor_role.id, :chorus_class_id => tag_class.id, :permissions_mask => create_permission_mask_for(tag_permissions, tag_class.class_operations))


puts ''
puts '---- Adding permissions for data scientist role ----'


user_permissions = %w(show update destroy create  change_password edit_dashboard manage_notifications manage_comments manage_notes manage_insights manage_data_source_credentials)
account_permissions = %w(create read view update delete change_password lock unlock)
group_permissions = %w(show update destroy create)
workspace_permissions = %w(show update destroy admin  create edit_settings add_members delete_members add_to_scope remove_from_scope  change_status explore_data transform_data download_data)
datasource_permissions = %w(show update destroy create  add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data)
note_permissions = %w(show update destroy create)
schema_permissions = %w(show update destroy create)
sandbox_permissions = %w(show update destroy create add_to_workspace delete_from_workspace)
comment_permissions = %w(show update destroy  create  promote_to_insight)
insight_permissions = %w(show update destroy create  promote demote publish unpublish)
workfile_permissions = %w(show update destroy create  run_workflow )
job_permissions = %w(show update destroy  create run stop)
task_permissions = %w(show update destroy create run stop)
milestome_permissions = %w(show update destroy create complete restart)
tag_permissions = %w(show update destroy create apply remove)

data_scientist_role.permissions << Permission.create(:role_id => data_scientist_role.id, :chorus_class_id => user_class.id, :permissions_mask => create_permission_mask_for(user_permissions, user_class.class_operations))
data_scientist_role.permissions << Permission.create(:role_id => data_scientist_role.id, :chorus_class_id => account_class.id, :permissions_mask => create_permission_mask_for(account_permissions, account_class.class_operations))
data_scientist_role.permissions << Permission.create(:role_id => data_scientist_role.id, :chorus_class_id => group_class.id, :permissions_mask => create_permission_mask_for(group_permissions, group_class.class_operations))
data_scientist_role.permissions << Permission.create(:role_id => data_scientist_role.id, :chorus_class_id => workspace_class.id, :permissions_mask => create_permission_mask_for(workspace_permissions, workspace_class.class_operations))
data_scientist_role.permissions << Permission.create(:role_id => data_scientist_role.id, :chorus_class_id => datasource_class.id, :permissions_mask => create_permission_mask_for(datasource_permissions, datasource_class.class_operations))
data_scientist_role.permissions << Permission.create(:role_id => data_scientist_role.id, :chorus_class_id => note_class.id, :permissions_mask => create_permission_mask_for(note_permissions, note_class.class_operations))
data_scientist_role.permissions << Permission.create(:role_id => data_scientist_role.id, :chorus_class_id => schema_class.id, :permissions_mask => create_permission_mask_for(schema_permissions, schema_class.class_operations))
data_scientist_role.permissions << Permission.create(:role_id => data_scientist_role.id, :chorus_class_id => sandbox_class.id, :permissions_mask => create_permission_mask_for(sandbox_permissions, sandbox_class.class_operations))
data_scientist_role.permissions << Permission.create(:role_id => data_scientist_role.id, :chorus_class_id => comment_class.id, :permissions_mask => create_permission_mask_for(comment_permissions, comment_class.class_operations))
data_scientist_role.permissions << Permission.create(:role_id => data_scientist_role.id, :chorus_class_id => insight_class.id, :permissions_mask => create_permission_mask_for(insight_permissions, insight_class.class_operations))
data_scientist_role.permissions << Permission.create(:role_id => data_scientist_role.id, :chorus_class_id => workfile_class.id, :permissions_mask => create_permission_mask_for(workfile_permissions, workfile_class.class_operations))
data_scientist_role.permissions << Permission.create(:role_id => data_scientist_role.id, :chorus_class_id => job_class.id, :permissions_mask => create_permission_mask_for(job_permissions, job_class.class_operations))
data_scientist_role.permissions << Permission.create(:role_id => data_scientist_role.id, :chorus_class_id => task_class.id, :permissions_mask => create_permission_mask_for(task_permissions, task_class.class_operations))
data_scientist_role.permissions << Permission.create(:role_id => data_scientist_role.id, :chorus_class_id => milestone_class.id, :permissions_mask => create_permission_mask_for(milestome_permissions, milestone_class.class_operations))
data_scientist_role.permissions << Permission.create(:role_id => data_scientist_role.id, :chorus_class_id => tag_class.id, :permissions_mask => create_permission_mask_for(tag_permissions, tag_class.class_operations))

puts ''
puts '---- Adding permissions for project developer role ----'

user_permissions = %w(show update destroy create  change_password edit_dashboard manage_notifications manage_comments manage_notes manage_insights manage_data_source_credentials)
account_permissions = %w(create read view update delete change_password lock unlock)
group_permissions = %w(show update destroy create)
workspace_permissions = %w(show update destroy admin  create edit_settings add_members delete_members add_to_scope remove_from_scope  change_status explore_data transform_data download_data)
datasource_permissions = %w(show update destroy create  add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data)
note_permissions = %w(show update destroy create)
schema_permissions = %w(show update destroy create)
sandbox_permissions = %w(show update destroy create add_to_workspace delete_from_workspace)
comment_permissions = %w(show update destroy  create  promote_to_insight)
insight_permissions = %w(show update destroy create  promote demote publish unpublish)
workfile_permissions = %w(show update destroy create  run_workflow )
job_permissions = %w(show update destroy  create run stop)
task_permissions = %w(show update destroy create run stop)
milestome_permissions = %w(show update destroy create complete restart)
tag_permissions = %w(show update destroy create apply remove)

project_developer_role.permissions << Permission.create(:role_id => project_developer_role.id, :chorus_class_id => user_class.id, :permissions_mask => create_permission_mask_for(user_permissions, user_class.class_operations))
project_developer_role.permissions << Permission.create(:role_id => project_developer_role.id, :chorus_class_id => account_class.id, :permissions_mask => create_permission_mask_for(account_permissions, account_class.class_operations))
project_developer_role.permissions << Permission.create(:role_id => project_developer_role.id, :chorus_class_id => group_class.id, :permissions_mask => create_permission_mask_for(group_permissions, group_class.class_operations))
project_developer_role.permissions << Permission.create(:role_id => project_developer_role.id, :chorus_class_id => workspace_class.id, :permissions_mask => create_permission_mask_for(workspace_permissions, workspace_class.class_operations))
project_developer_role.permissions << Permission.create(:role_id => project_developer_role.id, :chorus_class_id => datasource_class.id, :permissions_mask => create_permission_mask_for(datasource_permissions, datasource_class.class_operations))
project_developer_role.permissions << Permission.create(:role_id => project_developer_role.id, :chorus_class_id => note_class.id, :permissions_mask => create_permission_mask_for(note_permissions, note_class.class_operations))
project_developer_role.permissions << Permission.create(:role_id => project_developer_role.id, :chorus_class_id => schema_class.id, :permissions_mask => create_permission_mask_for(schema_permissions, schema_class.class_operations))
project_developer_role.permissions << Permission.create(:role_id => project_developer_role.id, :chorus_class_id => sandbox_class.id, :permissions_mask => create_permission_mask_for(sandbox_permissions, sandbox_class.class_operations))
project_developer_role.permissions << Permission.create(:role_id => project_developer_role.id, :chorus_class_id => comment_class.id, :permissions_mask => create_permission_mask_for(comment_permissions, comment_class.class_operations))
project_developer_role.permissions << Permission.create(:role_id => project_developer_role.id, :chorus_class_id => insight_class.id, :permissions_mask => create_permission_mask_for(insight_permissions, insight_class.class_operations))
project_developer_role.permissions << Permission.create(:role_id => project_developer_role.id, :chorus_class_id => workfile_class.id, :permissions_mask => create_permission_mask_for(workfile_permissions, workfile_class.class_operations))
project_developer_role.permissions << Permission.create(:role_id => project_developer_role.id, :chorus_class_id => job_class.id, :permissions_mask => create_permission_mask_for(job_permissions, job_class.class_operations))
project_developer_role.permissions << Permission.create(:role_id => project_developer_role.id, :chorus_class_id => task_class.id, :permissions_mask => create_permission_mask_for(task_permissions, task_class.class_operations))
project_developer_role.permissions << Permission.create(:role_id => project_developer_role.id, :chorus_class_id => milestone_class.id, :permissions_mask => create_permission_mask_for(milestome_permissions, milestone_class.class_operations))
project_developer_role.permissions << Permission.create(:role_id => project_developer_role.id, :chorus_class_id => tag_class.id, :permissions_mask => create_permission_mask_for(tag_permissions, tag_class.class_operations))

puts ''
puts "============== Adding Chorus Object ================="

puts ''
puts '--- Adding Users and it children objects ----'
User.all.each do |user|
    if ChorusClass.find_by_name(user.class.name) == nil
        ChorusClass.create(:name => user.class.name)
    end
    ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(user.class.name).id, :instance_id => user.id)
    user.gpdb_data_sources.each do |data_source|
        if ChorusClass.find_by_name(data_source.class.name) == nil
            ChorusClass.create(:name => data_source.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(data_source.class.name).id, :instance_id => data_source.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id)
    end
    user.oracle_data_sources.each do |data_source|
        if ChorusClass.find_by_name(data_source.class.name) == nil
            ChorusClass.create(:name => data_source.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(data_source.class.name).id, :instance_id => data_source.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id)
    end
    user.jdbc_data_sources.each do |data_source|
        if ChorusClass.find_by_name(data_source.class.name) == nil
            ChorusClass.create(:name => data_source.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(data_source.class.name).id, :instance_id => data_source.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id)
    end
    user.pg_data_sources.each do |data_source|
        if ChorusClass.find_by_name(data_source.class.name) == nil
            ChorusClass.create(:name => data_source.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(data_source.class.name).id, :instance_id => data_source.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id)
    end
    user.hdfs_data_sources.each do |data_source|
        if ChorusClass.find_by_name(data_source.class.name) == nil
            ChorusClass.create(:name => data_source.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(data_source.class.name).id, :instance_id => data_source.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id)
    end
    user.gnip_data_sources.each do |data_source|
        if ChorusClass.find_by_name(data_source.class.name) == nil
            ChorusClass.create(:name => data_source.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(data_source.class.name).id, :instance_id => data_source.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id)
    end
    user.data_source_accounts.each do |account|
        if ChorusClass.find_by_name(account.class.name) == nil
            ChorusClass.create(:name => account.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(account.class.name).id, :instance_id => account.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id)
    end
    user.memberships.each do |member|
        if ChorusClass.find_by_name(member.class.name) == nil
            ChorusClass.create(:name => member.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(member.class.name).id, :instance_id => member.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id)
    end
    user.owned_jobs.each do |job|
        if ChorusClass.find_by_name(job.class.name) == nil
            ChorusClass.create(:name => job.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(job.class.name).id, :instance_id => job.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id)
    end
    user.activities.each do |activity|
        if ChorusClass.find_by_name(activity.class.name) == nil
            ChorusClass.create(:name => activity.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(activity.class.name).id, :instance_id => activity.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id)
    end
    user.events.each do |event|
        if ChorusClass.find_by_name(event.class.name) == nil
            ChorusClass.create(:name => event.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(event.class.name).id, :instance_id => event.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id)
    end
    user.notifications.each do |notification|
        if ChorusClass.find_by_name(notification.class.name) == nil
            ChorusClass.create(:name => notification.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(notification.class.name).id, :instance_id => notification.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id)
    end
end


puts ''
puts '--- Adding Workspace and it children objects ----'

Workspace.all.each do |workspace|
    if ChorusClass.find_by_name(workspace.class.name) == nil
        ChorusClass.create(:name => workspace.class.name)
    end
    ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(workspace.class.name).id, :instance_id => workspace.id, :owner_id => workspace.owner.id)
    workspace.jobs.each do |job|
        if ChorusClass.find_by_name(job.class.name) == nil
            ChorusClass.create(:name => job.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(job.class.name).id, :instance_id => job.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id)
    end
    workspace.milestones.each do |milestone|
        if ChorusClass.find_by_name(milestone.class.name) == nil
            ChorusClass.create(:name => milestone.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(milestone.class.name).id, :instance_id => milestone.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id)
    end
    workspace.memberships.each do |membership|
        if ChorusClass.find_by_name(membership.class.name) == nil
            ChorusClass.create(:name => membership.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(membership.class.name).id, :instance_id => membership.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id)
    end
    workspace.workfiles.each do |workfile|
        if ChorusClass.find_by_name(workfile.class.name) == nil
            ChorusClass.create(:name => workfile.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(workfile.class.name).id, :instance_id => workfile.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id)
        workfile.activities.each do |activity|
            if ChorusClass.find_by_name(activity.class.name) == nil
                ChorusClass.create(:name => activity.class.name)
            end
            ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(activity.class.name).id, :instance_id  => activity.id, :owner_id => workspace.owner.id,  :parent_class_name => workfile.class.name, :parent_class_id => ChorusClass.find_by_name(workfile.class.name).id, :parent_id => workfile.id)
        end
        workfile.comments.each do |comment|
            if ChorusClass.find_by_name(comment.class.name) == nil
                ChorusClass.create(:name => comment.class.name)
            end
            ChorusObject.create(:chorus_class_id =>  ChorusClass.find_by_name(comment.class.name).id, :instance_id => comment.id, :owner_id => workfile.owner.id,  :parent_class_name => workfile.class.name, :parent_class_id => ChorusClass.find_by_name(workfile.class.name).id, :parent_id => workfile.id)
        end
    end
    workspace.activities.each do |activity|
        if ChorusClass.find_by_name(activity.class.name) == nil
            ChorusClass.create(:name => activity.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(activity.class.name).id, :instance_id => activity.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id)
    end
    #TODO: RPG. Don't know how to deal with events of differnt types in permissions framework. For now adding them as sub classes of (Events::Base)
    workspace.events.each do |event|
        if ChorusClass.find_by_name(event.class.name) == nil
            ChorusClass.create(:name => event.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(event.class.name).id, :instance_id => event.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id)
    end
    workspace.owned_notes.each do |note|
        if ChorusClass.find_by_name(note.class.name) == nil
            ChorusClass.create(:name => note.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(note.class.name).id, :instance_id => note.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id)
    end
    workspace.comments.each do |comment|
        if ChorusClass.find_by_name(comment.class.name) == nil
            ChorusClass.create(:name => comment.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(comment.class.name).id, :instance_id => comment.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id)
    end
    workspace.chorus_views.each do |view|
        if ChorusClass.find_by_name(view.class.name) == nil
            ChorusClass.create(:name => view.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(view.class.name).id, :instance_id => view.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id)
    end
    workspace.csv_files.each do |file|
        if ChorusClass.find_by_name(file.class.name) == nil
            ChorusClass.create(:name => file.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(file.class.name).id, :instance_id => file.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id)
    end
    workspace.associated_datasets.each do |dataset|
        if ChorusClass.find_by_name(dataset.class.name) == nil
            ChorusClass.create(:name => dataset.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(dataset.class.name).id, :instance_id => dataset.id, :owner_id => workspace.owner.id, :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id)
    end
    workspace.source_datasets.each do |dataset|
        if ChorusClass.find_by_name(dataset.class.name) == nil
            ChorusClass.create(:name => dataset.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(dataset.class.name).id, :instance_id => dataset.id, :owner_id => workspace.owner.id, :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id)
    end
    workspace.all_imports.each do |import|
        if ChorusClass.find_by_name(import.class.name) == nil
            ChorusClass.create(:name => import.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(import.class.name).id, :instance_id => import.id, :owner_id => workspace.owner.id, :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id)
    end
    workspace.imports.each do |import|
        if ChorusClass.find_by_name(import.class.name) == nil
            ChorusClass.create(:name => import.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(import.class.name).id, :instance_id => import.id, :owner_id => workspace.owner.id, :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id)
    end
    workspace.tags.each do |tag|
        if ChorusClass.find_by_name(tag.class.name) == nil
            ChorusClass.create(:name => tag.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(tag.class.name).id, :instance_id => tag.id, :owner_id => workspace.owner.id,  :parent_class_name => workspace.class.name, :parent_class_id => ChorusClass.find_by_name(workspace.class.name).id, :parent_id => workspace.id)
    end

end

puts ''
puts '--- Adding Data Sources and it children objects ----'

DataSource.all.each do |data_source|
    ChorusObject.create(:chorus_class_id => datasource_class.id, :instance_id => data_source.id, :owner_id => data_source.owner.id)
end


puts "============== FOLLOWING IS FOR TESTING PURPOSR ONLY ================="
puts ''
puts '--- Adding scopes ----'
#for testing only
scope_A = ChorusScope.create(:name => 'scope_A')
scope_B = ChorusScope.create(:name => 'scope_B')

puts ''
puts '---- Adding groups ----'
#for testing only
group_A = Group.create(:name => 'group_A')
group_B = Group.create(:name => 'group_B')

puts ''
puts '---- Assiging scopes to groups ----'
group_A.chorus_scope = scope_A
group_A.save!
group_B.chorus_scope = scope_B
group_B.save!

puts ''
puts '---- Randomly assigning workspace and data sources to scopes ----'
i = 0

User.all.each do |user|

    if i.even?
        puts "Adding #{user.username} to group A"
        group_A.users << user
    else
        puts "Adding #{user.username} to group B"
        group_B.users << user
    end
    i = i + 1

end

sa_count = 0
sb_count = 0

Workspace.all.each do |wspace|
    instance = ChorusObject.where(:instance_id => wspace.id, :chorus_class_id => workspace_class.id).first
    if group_A.users.where(:username => wspace.owner.username).count > 0
        instance.chorus_scope = scope_A
        instance.save!
        puts "adding workspace id = #{wspace.id} to scope A"
        sa_count = sa_count + 1
    elsif group_B.users.where(:username => wspace.owner.username).count > 0
        instance.chorus_scope = scope_B
        instance.save!
        puts "adding workspace id = #{wspace.id} to scope B"
        sb_count = sb_count + 1
    else
        puts "Can't find group for user = #{wspace.owner.username}"
    end
end


puts '------------------------------------------'
puts "Added #{sa_count} workspaces to scope_A"
puts "Added #{sb_count} workspaces to scope_B"
puts '------------------------------------------'


i = 0

DataSource.all.each do |data_source|
    instance =  ChorusObject.where(:instance_id => data_source.id, :chorus_class_id => datasource_class.id).first
    if group_A.users.where(:username => data_source.owner.username).count > 0
        instance.chorus_scope = scope_A
        instance.save!
        puts "adding data_source id = #{data_source.id} to scope A"
        sa_count = sa_count + 1
    elsif group_B.users.where(:username => data_source.owner.username).count > 0
        instance.chorus_scope = scope_B
        instance.save!
        puts "adding data_source id = #{data_source.id} to scope B"
        sb_count = sb_count + 1
    else
        puts "Can't find group for user = #{data_source.owner.username}"
    end
end







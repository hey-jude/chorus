# Seed roles groups and permissions
# roles
puts ''
puts '---- Adding Roles ----'
admin_role = Role.create(:name => 'admin'.camelize)
owner_role = Role.create(:name => 'owner'.camelize)
user_role = Role.create(:name => 'user'.camelize)
developer_role = Role.create(:name => 'developer'.camelize)
collaborator_role = Role.create(:name => 'collaborator'.camelize)
site_admin_role = Role.create(:name => 'site_administrator'.camelize)
app_admin_role = Role.create(:name => 'application_administrator'.camelize)
app_manager_role = Role.create(:name => 'application_manager'.camelize)
workflow_developer_role = Role.create(:name => 'workflow_developer'.camelize)
project_manager_role = Role.create(:name => 'project_manager'.camelize)
project_developer_role = Role.create(:name => 'project_developer'.camelize)
contributor_role = Role.create(:name => 'contributor'.camelize)
data_scientist_role = Role.create(:name => 'data_scientist'.camelize)

puts ''
puts '---- Adding permissions ----'

chorusadmin = User.find_by_username("chorusadmin")

admin_role.users << chorusadmin if chorusadmin


# Groups
puts '---- Adding Default Group  ----'
default_group = Group.create(:name => 'default_group')
# Scope
puts ''
puts '---- Adding application_realm as Default Scope ----'
application_realm = ChorusScope.create(:name => 'application_realm')
# add application_realm to default group
default_group.chorus_scope = application_realm

admin_role.groups << default_group

#Role.all.each do |role|
#    role.groups << default_group
#end



# permissions

puts ''
puts '---- Adding Chorus object classes  ----'
ChorusClass.create(
    [
        {:name => 'activity'.camelize},
        {:name => 'account'.camelize},
        {:name => 'alpine_workfile'.camelize},
        {:name => 'associated_dataset'.camelize},
        {:name => 'chorus_scope'.camelize},
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
        {:name => 'open_workfile_event'.camelize},
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
        {:name => 'workflow'.camelize},
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
        {:name => 'events::Base'.camelize},
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

role_class = ChorusClass.where(:name => 'role'.camelize).first
chorus_scope_class = ChorusClass.where(:name => 'chorus_scope'.camelize).first
workspace_class = ChorusClass.where(:name => 'workspace'.camelize).first
user_class = ChorusClass.where(:name => 'user'.camelize).first
account_class = ChorusClass.where(:name => 'account'.camelize).first
datasource_class = ChorusClass.where(:name => 'data_source'.camelize).first
datasource_class = ChorusClass.where(:name => 'data_source'.camelize).first
group_class = ChorusClass.where(:name => 'group'.camelize).first
database_class = ChorusClass.where(:name => 'database'.camelize).first
job_class  = ChorusClass.where(:name => 'job'.camelize).first
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
tag_class = ChorusClass.where(:name => 'tag'.camelize).first
schema_class = ChorusClass.where(:name => 'schema'.camelize).first
task_class = ChorusClass.where(:name => 'task'.camelize).first
insight_class = ChorusClass.where(:name => 'insight'.camelize).first
upload_class = ChorusClass.where(:name => 'upload'.camelize).first

job_class.update_attributes({:parent_class_name => 'workspace'.camelize}, {:parent_class_id => workspace_class.id} )
milestone_class.update_attributes({:parent_class_name => 'workspace'.camelize}, {:parent_class_id => workspace_class.id} )
membership_class.update_attributes({:parent_class_name => 'workspace'.camelize}, {:parent_class_id => workspace_class.id} )
workfile_class.update_attributes({:parent_class_name => 'workspace'.camelize}, {:parent_class_id => workspace_class.id} )
workflow_class.update_attributes({:parent_class_name => 'workspace'.camelize}, {:parent_class_id => workspace_class.id} )
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

class_operations = {
    'Events::Base' => %w(create show update destroy create_comment_on create_attachment_on),
    'Role' =>         %w(create show update destroy manage_application_roles manage_workspace_roles),
    'ChorusScope' =>  %w(create show update destroy manage_scopes),
    'User' =>         %w(create show update destroy change_password edit_dashboard manage_notifications manage_comments manage_notes manage_insights manage_data_source_credentials ldap),
    'Account' =>      %w(create show update destroy change_password lock unlock),
    'Group' =>        %w(create show update destroy),
    'Workspace' =>    %w(create show update destroy admin create_workflow edit_settings add_members delete_members add_to_scope remove_from_scope add_sandbox delete_sandbox change_status add_data remove_data explore_data transform_data download_data),
    'DataSource' =>   %w(create show update destroy add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data),
    'Note' =>         %w(create show update destroy create_attachment_on demote_from_insight),
    'Schema' =>       %w(create show update destroy),
    'Sandbox' =>      %w(create show update destroy add_to_workspace delete_from_workspace),
    'Comment' =>      %w(create show update destroy promote_to_insight),
    'Workfile' =>     %w(create show update destroy create_workflow run_workflow),
    'Workflow' =>     %w(create show update destroy run stop open),
    'Job' =>          %w(create show update destroy run stop),
    'Task' =>         %w(create show update destroy run stop),
    'Milestone' =>    %w(create show update destroy complete restart),
    'Tag' =>          %w(create show update destroy apply remove),
    'Upload' =>       %w(create show update destroy),
    'Import' =>       %w(create show update destroy),
    'Notification' => %w(create show update destroy),
    'CsvFile' =>      %w(create show update destroy)
}

class_operations.each do |class_name, operations|
  chorus_class = ChorusClass.find_by_name(class_name)
    operations.each_with_index do |operation, index|
      chorus_class.operations << Operation.create(:name => operation, :sequence => index )
    end
end

puts ''
puts '=================== Adding permissions to Roles ======================'



role_permissions = {
  'Admin' => {
    'Events::Base' => %w(create show update destroy create_comment_on create_attachment_on),
    'ChorusScope' =>  %w(create show update destroy manage_scopes),
    'Role' =>         %w(create show update destroy manage_application_roles manage_workspace_roles),
    'User' =>         %w(create show update destroy change_password edit_dashboard manage_notifications manage_comments manage_notes manage_insights manage_data_source_credentials ldap),
    'Account' =>      %w(create show update destroy change_password lock unlock),
    'Group' =>        %w(create show update destroy),
    'Workspace' =>    %w(create show update destroy admin create_workflow edit_settings add_members delete_members add_to_scope remove_from_scope add_sandbox delete_sandbox change_status add_data remove_data explore_data transform_data download_data),
    'DataSource' =>   %w(create show update destroy add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data),
    'Note' =>         %w(create show update destroy create_attachment_on demote_from_insight),
    'Schema' =>       %w(create show update destroy),
    'Sandbox' =>      %w(create show update destroy add_to_workspace delete_from_workspace),
    'Comment' =>      %w(create show update destroy promote_to_insight),
    'Workfile' =>     %w(create show update destroy create_workflow run_workflow),
    'Workflow' =>     %w(create show update destroy run stop open),
    'Job' =>          %w(create show update destroy run stop),
    'Task' =>         %w(create show update destroy run stop),
    'Milestone' =>    %w(create show update destroy complete restart),
    'Tag' =>          %w(create show update destroy apply remove),
    'Upload' =>       %w(create show update destroy),
    'Import' =>       %w(create show update destroy),
    'Notification' => %w(create show update destroy),
    'CsvFile' =>      %w(create show update destroy)

},

  'Owner' => {
    'Events::Base' => %w(create show update destroy create_comment_on create_attachment_on),
    'ChorusScope' =>  %w(create show update destroy manage_scopes),
    'Role' =>         %w(create show update destroy manage_application_roles manage_workspace_roles),
    'User' =>         %w(show change_password edit_dashboard manage_notifications manage_comments manage_notes manage_insights manage_data_source_credentials),
    'Account' =>      %w(create show update destroy change_password lock unlock),
    'Group' =>        %w(show update destroy create),
    'Workspace' =>    %w(show update destroy admin create edit_settings add_members delete_members add_to_scope remove_from_scope  change_status explore_data transform_data download_data),
    'DataSource' =>   %w(show update destroy create add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data),
    'Note' =>         %w(show update destroy create),
    'Schema' =>       %w(show update destroy create),
    'Sandbox' =>      %w(show update destroy create add_to_workspace delete_from_workspace),
    'Comment' =>      %w(show update destroy create promote_to_insight),
    'Workfile' =>     %w(show update destroy create create_workflow run_workflow ),
    'Workflow' =>     %w(create show update destroy run stop open),
    'Job' =>          %w(show update destroy create run stop),
    'Task' =>         %w(show update destroy create run stop),
    'Milestone' =>    %w(show update destroy create complete restart),
    'Tag' =>          %w(show update destroy create apply remove),
    'Upload' =>       %w(create show update destroy),
    'Import' =>       %w(create show update destroy),
    'Notification' => %w(create show update destroy),
    'CsvFile' =>      %w(create show update destroy)
  },

  'Developer' => {
    'Events::Base' => %w(create show update destroy create_comment_on create_attachment_on),
    'ChorusScope' =>  %w(create show update destroy manage_scopes),
    'Role' =>         %w(create show update destroy manage_application_roles manage_workspace_roles),
    'User' =>         %w(show change_password edit_dashboard manage_notifications manage_comments manage_notes manage_insights manage_data_source_credentials),
    'Account' =>      %w(create show update destroy change_password lock unlock),
    'Group' =>        %w(show update destroy create),
    'Workspace' =>    %w(show update destroy admin create edit_settings add_members delete_members add_to_scope remove_from_scope  change_status explore_data transform_data download_data),
    'Workflow' =>     %w(create show update destroy run stop open),
    'DataSource' =>   %w(show update destroy create add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data),
    'Note' =>         %w(show update destroy create),
    'Schema' =>       %w(show update destroy create),
    'Sandbox' =>      %w(show update destroy create add_to_workspace delete_from_workspace),
    'Comment' =>      %w(show update destroy create promote_to_insight),
    'Workfile' =>     %w(show update destroy create create_workflow run_workflow ),
    'Workflow' =>     %w(create show update destroy run stop open),
    'Job' =>          %w(show update destroy create run stop),
    'Task' =>         %w(show update destroy create run stop),
    'Milestone' =>    %w(show update destroy create complete restart),
    'Tag' =>          %w(show update destroy create apply remove),
    'Upload' =>       %w(create show update destroy),
    'Import' =>       %w(create show update destroy),
    'Notification' => %w(create show update destroy),
    'CsvFile' =>      %w(create show update destroy)

  },

  'Collaborator' => {
    'Events::Base' => %w(create_comment_on create_attachment_on),
    'ChorusScope' =>  %w(),
    'Role' =>         %w(),
    'User' =>         %w(),
    'Account' =>      %w(),
    'Group' =>        %w(),
    'Workspace' =>    %w(),
    'DataSource' =>   %w(show),
    'Note' =>         %w(show create),
    'Schema' =>       %w(),
    'Sandbox' =>      %w(),
    'Comment' =>      %w(show create promote_to_insight),
    'Workfile' =>     %w(),
    'Workflow' =>     %w(),
    'Job' =>          %w(),
    'Task' =>         %w(),
    'Milestone' =>    %w(),
    'Tag' =>          %w(show create apply remove),
    'Upload' =>       %w(),
    'Import' =>       %w(),
    'Notification' => %w(),
    'CsvFile' =>      %w()

  },
  

  'SiteAdministrator' => {
    'Events::Base' =>  %w(create show update destroy create_comment_on create_attachment_on),
    'ChorusScope' =>   %w(create show update destroy manage_scopes),
    'Role' =>          %w(create create update destroy manage_application_roles manage_workspace_roles),
    'User' =>          %w(show update destroy create  change_password edit_dashboard manage_notifications manage_comments manage_notes manage_insights manage_data_source_credentials),
    'Account' =>       %w(create show update destroy change_password lock unlock),
    'Group' =>         %w(show update destroy create),
    'Workspace' =>     %w(show update destroy admin create edit_settings add_members delete_members add_to_scope remove_from_scope  change_status explore_data transform_data download_data),
    'DataSource' =>    %w(show update destroy create add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data),
    'Note' =>          %w(show update destroy create),
    'Schema' =>        %w(show update destroy create),
    'Sandbox' =>       %w(show update destroy create add_to_workspace delete_from_workspace),
    'Comment' =>       %w(show update destroy create promote_to_insight),
    'Workfile' =>      %w(show update destroy create create_workflow run_workflow),
    'Workflow' =>     %w(create show update destroy run stop open),
    'Job' =>           %w(show update destroy  create run stop),
    'Task' =>          %w(show update destroy create run stop),
    'Milestone' =>     %w(show update destroy create complete restart),
    'Tag' =>           %w(show update destroy create apply remove),
    'Upload' =>        %w(create show update destroy),
    'Import' =>        %w(create show update destroy),
    'Notification' =>  %w(create show update destroy),
    'CsvFile' =>       %w(create show update destroy)
  },
  

  'ApplicationAdministrator' => {
    'Events::Base' => %w(create show update destroy create_comment_on create_attachment_on),
    'ChorusScope' =>  %w(create show update destroy manage_scopes),
    'Role' =>         %w(create create update destroy manage_application_roles manage_workspace_roles),
    'User' =>         %w(show update destroy create  change_password edit_dashboard manage_notifications manage_comments manage_notes manage_insights manage_data_source_credentials),
    'Account' =>      %w(create show update destroy change_password lock unlock),
    'Group' =>        %w(show update destroy create),
    'Workspace' =>    %w(show update destroy admin create edit_settings add_members delete_members add_to_scope remove_from_scope change_status explore_data transform_data download_data),
    'DataSource' =>   %w(show update destroy create add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data),
    'Note' =>         %w(show update destroy create),
    'Schema' =>       %w(show update destroy create),
    'Sandbox' =>      %w(show update destroy create add_to_workspace delete_from_workspace),
    'Comment' =>      %w(show update destroy create promote_to_insight),
    'Workfile' =>     %w(show update destroy create run_workflow ),
    'Workflow' =>     %w(create show update destroy run stop open),
    'Job' =>          %w(show update destroy create run stop),
    'Task' =>         %w(show update destroy create run stop),
    'Milestone' =>    %w(show update destroy create complete restart),
    'Tag' =>          %w(show update destroy create apply remove),
    'Upload' =>       %w(create show update destroy),
    'Import' =>       %w(create show update destroy),
    'Notification' => %w(create show update destroy),
    'CsvFile' =>      %w(create show update destroy)
  },
  

  'ApplicationManager' => {
    'Events::Base' => %w(create_comment_on create_attachment_on),
    'ChorusScope' =>  %w(),
    'Role' =>         %w(manage_workspace_roles),
    'User' =>         %w(),
    'Account' =>      %w(),
    'Group' =>        %w(show update destroy create),
    'Workspace' =>    %w(show update destroy admin create edit_settings add_members delete_members add_to_scope remove_from_scope change_status explore_data transform_data download_data),
    'DataSource' =>   %w(show update destroy create add_data remove_data explore_data download_data),
    'Note' =>         %w(show update destroy create),
    'Schema' =>       %w(show),
    'Sandbox' =>      %w(show),
    'Comment' =>      %w(show update destroy create promote_to_insight),
    'Workfile' =>     %w(),
    'Workflow' =>     %w(),
    'Job' =>          %w(),
    'Task' =>         %w(),
    'Milestone' =>    %w(),
    'Tag' =>          %w(show update destroy create apply remove),
    'Upload' =>       %w(create show update destroy),
    'Import' =>       %w(),
    'Notification' => %w(create show update destroy),
    'CsvFile' =>      %w(create show update destroy)
  },
  
  'WorkflowDeveloper' => {
    'Events::Base' =>  %w(),
    'ChorusScope' =>   %w(),
    'Role' =>          %w(),
    'User' =>          %w(),
    'Account' =>       %w(),
    'Group' =>         %w(),
    'Workspace' =>     %w(),
    'DataSource' =>    %w(),
    'Note' =>          %w(),
    'Schema' =>        %w(),
    'Sandbox' =>       %w(),
    'Comment' =>       %w(),
    'Workfile' =>      %w(create create_workflow run_workflow),
    'Workflow' =>     %w(create show update destroy run stop open),
    'Job' =>           %w(),
    'Task' =>          %w(),
    'Milestone' =>     %w(),
    'Tag' =>           %w(),
    'Upload' =>        %w(),
    'Import' =>        %w(),
    'Notification' =>  %w(),
    'CsvFile' =>      %w(create show update destroy)
  },

  'ProjectManager' => {
    'Events::Base' => %w(show create create_comment_on create_attachment_on),
    'ChorusScope' =>  %w(),
    'Role' =>         %w(),
    'User' =>         %w(),
    'Account' =>      %w(),
    'Group' =>        %w(),
    'Workspace' =>    %w(show update create edit_settings add_members delete_members add_to_scope remove_from_scope change_status explore_data transform_data download_data),
    'DataSource' =>   %w(),
    'Note' =>         %w(show update destroy create),
    'Schema' =>       %w(),
    'Sandbox' =>      %w(),
    'Comment' =>      %w(show update destroy create promote_to_insight),
    'Workfile' =>     %w(show update destroy create run_workflow),
    'Workflow' =>     %w(create show update destroy run stop open),
    'Job' =>          %w(show update destroy create run stop),
    'Task' =>         %w(show update destroy create run stop),
    'Milestone' =>    %w(show update destroy create complete restart),
    'Tag' =>          %w(show update destroy create apply remove),
    'Upload' =>       %w(create show update destroy),
    'Import' =>       %w(create show update destroy),
    'Notification' => %w(create show update destroy),
    'CsvFile' =>      %w(create show update destroy)
  },
  
  'Contributor' => {
    'Events::Base' =>  %w(show create create_comment_on create_attachment_on),
    'ChorusScope' =>   %w(),
    'Role' =>          %w(),
    'User' =>          %w(),
    'Account' =>       %w(),
    'Group' =>         %w(),
    'Workspace' =>     %w(show explore_data transform_data download_data),
    'DataSource' =>    %w(),
    'Note' =>          %w(show create),
    'Schema' =>        %w(),
    'Sandbox' =>       %w(),
    'Comment' =>       %w(show create promote_to_insight),
    'Workfile' =>      %w(show create),
    'Workflow' =>      %w(),
    'Job' =>           %w(show update destroy create run stop),
    'Task' =>          %w(show update destroy create run stop),
    'Milestone' =>     %w(),
    'Tag' =>           %w(show update destroy create apply remove),
    'Upload' =>        %w(create show update destroy),
    'Import' =>        %w(create show update destroy),
    'Notification' =>  %w(create show update destroy),
    'CsvFile' =>      %w(create show update destroy)
  },
  
  'ProjectDeveloper' => {
    'Events::Base' => %w(show create create_comment_on create_attachment_on),
    'ChorusScope' =>  %w(),
    'Role' =>         %w(),
    'User' =>         %w(),
    'Account' =>      %w(),
    'Group' =>        %w(),
    'Workspace' =>    %w(show create explore_data transform_data download_data),
    'DataSource' =>   %w(show explore_data download_data),
    'Note' =>         %w(show create),
    'Schema' =>       %w(),
    'Sandbox' =>      %w(),
    'Comment' =>      %w(show create promote_to_insight),
    'Workfile' =>     %w(show create),
    'Workflow' =>     %w(create show update),
    'Job' =>          %w(show update destroy create run stop),
    'Task' =>         %w(show update destroy create run stop),
    'Milestone' =>    %w(),
    'Tag' =>          %w(show update destroy create apply remove),
    'Upload' =>       %w(create show update destroy),
    'Import' =>       %w(create show update destroy),
    'Notification' => %w(create show update destroy),
    'CsvFile' =>      %w(create show update destroy)
  }
}

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


role_permissions.each do |role_name, permissions_hash|
    role = Role.find_by_name(role_name)
    #puts "---- Adding permissions for #{role_name} role ----"

    permissions_hash.each do |class_name, permission_names|
        chorus_class = ChorusClass.find_by_name(class_name)
        puts "---- Adding permissions for #{role_name} role and #{class_name} ----"
        role.permissions << Permission.create(:role_id => role.id,
                                              :chorus_class_id => chorus_class.id, 
                                              :permissions_mask => create_permission_mask_for(permission_names, chorus_class.class_operations))
    end
end


puts ''
puts "===================== Migrating users to new roles =========================="
puts ''

User.all.each do |user|

  if user.admin
    user.roles << admin_role unless user.roles.include? admin_role
  end
  if user.developer
    user.roles << project_developer_role unless user.roles.include? project_developer_role
    user.roles << workflow_developer_role unless user.roles.include? workflow_developer_role
  end
  user.roles << collaborator_role unless user.roles.include? collaborator_role

end


puts ''
puts "===================== Adding Chorus Object =========================="

puts ''
puts '--- Adding Users and children objects ----'

User.all.each do |user|
    if ChorusClass.find_by_name(user.class.name) == nil
        ChorusClass.create(:name => user.class.name)
    end
    user_object = ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(user.class.name).id, :instance_id => user.id)
    user_object.chorus_object_roles << ChorusObjectRole.create(:chorus_object_id => user_object.id, :user_id => user.id, :role_id => user_role.id)

    #user_object_role = ChorusObjectRole.create(:chorus_object_id => user_object.id, :user_id => user.id, :role_id => user_role.id)
    # add all users to default scope (application realm) by adding user to the default group
    #user.chorus_scopes << application_realm
    user.groups << default_group

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

    user.open_workfile_events.each do |event|
        if ChorusClass.find_by_name(event.class.name) == nil
            ChorusClass.create(:name => event.class.name)
        end
        ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(event.class.name).id, :instance_id => event.id, :owner_id => user.id, :parent_class_name => user.class.name, :parent_class_id => ChorusClass.find_by_name(user.class.name).id, :parent_id => user.id)
    end
end


puts ''
puts '--- Adding Workspace and  children objects ----'

Workspace.all.each do |workspace|
    if ChorusClass.find_by_name(workspace.class.name) == nil
        ChorusClass.create(:name => workspace.class.name)
    end

    # Add owner as workspace role
    workspace_object = ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(workspace.class.name).id, :instance_id => workspace.id, :owner_id => workspace.owner.id)
    workspace_object.chorus_object_roles << ChorusObjectRole.create(:chorus_object_id => workspace_object.id, :user_id => workspace.owner.id, :role_id => owner_role.id)

    #workspace_object_role = ChorusObjectRole.create(:chorus_object_id => workspace_object.id, :user_id => workspace.owner.id, :role_id => owner_role.id)
    #workspace.owner.object_roles << workspace_object_role

    #children = %w(jobs milestones memberships workfiles activities events owned_notes comments chorus_views csv_files associated_datasets source_datasets all_imports imports tags)

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
        workfile.events.each do |event|
          if ChorusClass.find_by_name(event.class.name) == nil
            ChorusClass.create(:name => event.class.name)
          end
          ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(event.class.name).id, :instance_id  => event.id, :owner_id => workspace.owner.id,  :parent_class_name => workfile.class.name, :parent_class_id => ChorusClass.find_by_name(workfile.class.name).id, :parent_id => workfile.id)
        end
        workfile.open_workfile_events.each do |event|
          if ChorusClass.find_by_name(event.class.name) == nil
            ChorusClass.create(:name => event.class.name)
          end
          ChorusObject.create(:chorus_class_id => ChorusClass.find_by_name(event.class.name).id, :instance_id  => event.id, :owner_id => workspace.owner.id,  :parent_class_name => workfile.class.name, :parent_class_id => ChorusClass.find_by_name(workfile.class.name).id, :parent_id => workfile.id)
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

puts ''
puts '--- Assign application_realm scope to all objects ---'

ChorusObject.all.each do |chorus_object|
  chorus_object.chorus_scope = application_realm
  chorus_object.save!
end





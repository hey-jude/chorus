#
# Seed roles groups and permissions
# roles
puts ''
puts '---- Adding Roles ----'
admin_role = Role.find_or_create_by_name(:name => 'admin'.camelize)
owner_role = Role.find_or_create_by_name(:name => 'owner'.camelize)
user_role = Role.find_or_create_by_name(:name => 'user'.camelize)
collaborator_role = Role.find_or_create_by_name(:name => 'collaborator'.camelize)
site_admin_role = Role.find_or_create_by_name(:name => 'site_administrator'.camelize)
app_admin_role = Role.find_or_create_by_name(:name => 'application_administrator'.camelize)
app_manager_role = Role.find_or_create_by_name(:name => 'application_manager'.camelize)
workflow_developer_role = Role.find_or_create_by_name(:name => 'workflow_developer'.camelize)
project_manager_role = Role.find_or_create_by_name(:name => 'project_manager'.camelize)
project_developer_role = Role.find_or_create_by_name(:name => 'project_developer'.camelize)
contributor_role = Role.find_or_create_by_name(:name => 'contributor'.camelize)
data_scientist_role = Role.find_or_create_by_name(:name => 'data_scientist'.camelize)

admins = User.where(:admin => true).all

admins.each do |admin|
  admin.roles << admin_role unless admin.roles.include?(admin_role)
  admin.roles << app_manager_role unless admin.roles.include?(app_manager_role)
end
#puts ''
#puts '---- Adding permissions ----'

chorusadmin = User.find_by_username("chorusadmin")

site_admin_role.users << chorusadmin if chorusadmin && !site_admin_role.users.include?(chorusadmin)
admin_role.users << chorusadmin if chorusadmin && !admin_role.users.include?(chorusadmin)

# Groups
puts '---- Adding Default Group  ----'
default_group = Group.find_or_create_by_name(:name => 'default_group')
# Scope
puts ''
puts '---- Adding application_realm as Default Scope ----'
application_realm = ChorusScope.find_or_create_by_name(:name => 'application_realm')
# add application_realm to default group
default_group.chorus_scope = application_realm

collaborator_role.groups << default_group unless collaborator_role.groups.include? default_group

#Role.all.each do |role|
#    role.groups << default_group
#end



# permissions

puts ''
puts '---- Adding Chorus object classes  ----'

chorus_classes =  [
        {:name => 'Events::Base'},
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
        {:name => 'gpdb_dataset'.camelize},
        {:name => 'gpdb_database'.camelize},
        {:name => 'gpdb_dataset_column'.camelize},
        {:name => 'gpdb_schema'.camelize},
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
        {:name => 'published_worklet'.camelize},
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
        {:name => 'worklet'.camelize},
        {:name => 'workspace'.camelize},
        {:name => 'workspace_import'.camelize},
        {:name => 'workspace_search'.camelize},
        {:name => 'recent_workfiles'.camelize},
        {:name => 'site_snapshot'.camelize},
        {:name => 'workspace_activity'.camelize},
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
        {:name => 'boxplot'.camelize},
        {:name => 'frequency'.camelize},
        {:name => 'heatmap'.camelize},
        {:name => 'histograp'.camelize},
        {:name => 'timeseries'.camelize}
    ]

chorus_classes.each do |chorus_class|
    ChorusClass.find_or_create_by_name(chorus_class)
end


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
    'Events::Base' =>  %w(create show update destroy create_comment_on create_attachment_on),
    'Role' =>          %w(create show update destroy manage_application_roles manage_workspace_roles),
    'ChorusScope' =>   %w(create show update destroy manage_scopes),
    'User' =>          %w(create show update destroy change_password edit_dashboard manage_notifications manage_comments manage_notes manage_insights manage_data_source_credentials ldap),
    'DataSourceAccount' =>       %w(create show update destroy change_password lock unlock),
    'Group' =>         %w(create show update destroy),
    'Workspace' =>     %w(create show update destroy admin create_workflow edit_settings add_members delete_members add_to_scope remove_from_scope add_sandbox delete_sandbox change_status add_data remove_data explore_data transform_data download_data),
    'DataSource' =>    %w(create show update destroy add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data),
    'HdfsDataSource'=> %w(create show update destroy add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data),
    'GnipDataSource'=> %w(create show update destroy add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data),
    'Note' =>          %w(create show update destroy create_attachment_on demote_from_insight),
    'Schema' =>        %w(create show update destroy),
    'Sandbox' =>       %w(create show update destroy add_to_workspace delete_from_workspace),
    'Comment' =>       %w(create show update destroy promote_to_insight),
    'Workfile' =>      %w(create show update destroy create_workflow run_workflow),
    'Workflow' =>      %w(create show update destroy run stop open),
    'Job' =>           %w(create show update destroy run stop),
    'Task' =>          %w(create show update destroy run stop),
    'Milestone' =>     %w(create show update destroy complete restart),
    'Tag' =>           %w(create show update destroy apply remove),
    'Upload' =>        %w(create show update destroy),
    'Import' =>        %w(create show update destroy),
    'Notification' =>  %w(create show update destroy),
    'CsvFile' =>       %w(create show update destroy)
}

Operation.destroy_all
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
     'Events::Base' =>  %w(create show update destroy create_comment_on create_attachment_on),
     'Role' =>          %w(create show update destroy manage_application_roles manage_workspace_roles),
     'ChorusScope' =>   %w(create show update destroy manage_scopes),
     'User' =>          %w(create show update destroy change_password edit_dashboard manage_notifications manage_comments manage_notes manage_insights manage_data_source_credentials ldap),
     'DataSourceAccount' =>       %w(create show update destroy change_password lock unlock),
     'Group' =>         %w(create show update destroy),
     'Workspace' =>     %w(create show update destroy admin create_workflow edit_settings add_members delete_members add_to_scope remove_from_scope add_sandbox delete_sandbox change_status add_data remove_data explore_data transform_data download_data),
     'DataSource' =>    %w(create show update destroy add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data),
     'HdfsDataSource'=> %w(create show update destroy add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data),
     'GnipDataSource'=> %w(create show update destroy add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data),
     'Note' =>          %w(create show update destroy create_attachment_on demote_from_insight),
     'Schema' =>        %w(create show update destroy),
     'Sandbox' =>       %w(create show update destroy add_to_workspace delete_from_workspace),
     'Comment' =>       %w(create show update destroy promote_to_insight),
     'Workfile' =>      %w(create show update destroy create_workflow run_workflow),
     'Workflow' =>      %w(create show update destroy run stop open),
     'Job' =>           %w(create show update destroy run stop),
     'Task' =>          %w(create show update destroy run stop),
     'Milestone' =>     %w(create show update destroy complete restart),
     'Tag' =>           %w(create show update destroy apply remove),
     'Upload' =>        %w(create show update destroy),
     'Import' =>        %w(create show update destroy),
     'Notification' =>  %w(create show update destroy),
     'CsvFile' =>       %w(create show update destroy)

 },

  'Owner' => {
    'Events::Base' => %w(create show update destroy create_comment_on create_attachment_on),
    'Role' =>         %w(create show update destroy manage_application_roles manage_workspace_roles),
    'ChorusScope' =>  %w(create show update destroy manage_scopes),
    'User' =>         %w(show change_password edit_dashboard manage_notifications manage_comments manage_notes manage_insights manage_data_source_credentials),
    'DataSourceAccount' =>      %w(create show update destroy change_password lock unlock),
    'Group' =>        %w(create show update destroy),
    'Workspace' =>    %w(create show update destroy admin edit_settings add_members delete_members add_to_scope remove_from_scope change_status explore_data transform_data download_data),
    'DataSource' =>   %w(create show update destroy add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data),
    'HdfsDataSource'=>%w(create show update destroy add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data),
    'GnipDataSource'=>%w(create show update destroy add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data),
    'Note' =>         %w(create show update destroy),
    'Schema' =>       %w(create show update destroy),
    'Sandbox' =>      %w(create show update destroy add_to_workspace delete_from_workspace),
    'Comment' =>      %w(create show update destroy promote_to_insight),
    'Workfile' =>     %w(create show update destroy create_workflow run_workflow ),
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

  'Collaborator' => {
    'Events::Base' => %w(create_comment_on create_attachment_on),
    'ChorusScope' =>  %w(),
    'Role' =>         %w(),
    'User' =>         %w(),
    'DataSourceAccount' =>      %w(),
    'Group' =>        %w(),
    'Workspace' =>    %w(),
    'DataSource' =>   %w(show),
    'HdfsDataSource'=>%w(show),
    'GnipDataSource'=>%w(show),
    'Note' =>         %w(create show),
    'Schema' =>       %w(),
    'Sandbox' =>      %w(),
    'Comment' =>      %w(create show promote_to_insight),
    'Workfile' =>     %w(),
    'Workflow' =>     %w(),
    'Job' =>          %w(),
    'Task' =>         %w(),
    'Milestone' =>    %w(),
    'Tag' =>          %w(create show apply remove),
    'Upload' =>       %w(),
    'Import' =>       %w(),
    'Notification' => %w(),
    'CsvFile' =>      %w()

  },

  'User' => {
      'Events::Base' => %w(create_comment_on create_attachment_on),
      'ChorusScope' =>  %w(),
      'Role' =>         %w(),
      'User' =>         %w(),
      'DataSourceAccount' =>      %w(),
      'Group' =>        %w(),
      'Workspace' =>    %w(),
      'DataSource' =>   %w(show),
      'HdfsDataSource'=>%w(show),
      'GnipDataSource'=>%w(show),
      'Note' =>         %w(create show),
      'Schema' =>       %w(),
      'Sandbox' =>      %w(),
      'Comment' =>      %w(create show promote_to_insight),
      'Workfile' =>     %w(),
      'Workflow' =>     %w(),
      'Job' =>          %w(),
      'Task' =>         %w(),
      'Milestone' =>    %w(),
      'Tag' =>          %w(create show apply remove),
      'Upload' =>       %w(),
      'Import' =>       %w(),
      'Notification' => %w(),
      'CsvFile' =>      %w()

  },
  

  'SiteAdministrator' => {
    'Events::Base' =>  %w(create show update destroy create_comment_on create_attachment_on),
    'ChorusScope' =>   %w(create show update destroy manage_scopes),
    'Role' =>          %w(create show update destroy manage_application_roles manage_workspace_roles),
    'User' =>          %w(create show update destroy change_password edit_dashboard manage_notifications manage_comments manage_notes manage_insights manage_data_source_credentials),
    'DataSourceAccount' =>       %w(create show update destroy change_password lock unlock),
    'Group' =>         %w(create show update destroy),
    'Workspace' =>     %w(create show update destroy admin edit_settings add_members delete_members add_to_scope remove_from_scope  change_status explore_data transform_data download_data),
    'DataSource' =>    %w(create show update destroy add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data),
    'HdfsDataSource'=> %w(create show update destroy add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data),
    'GnipDataSource'=> %w(create show update destroy add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data),
    'Note' =>          %w(create show update destroy),
    'Schema' =>        %w(create show update destroy),
    'Sandbox' =>       %w(create show update destroy add_to_workspace delete_from_workspace),
    'Comment' =>       %w(create show update destroy promote_to_insight),
    'Workfile' =>      %w(create show update destroy create_workflow run_workflow),
    'Workflow' =>      %w(create show update destroy run stop open),
    'Job' =>           %w(create show update destroy run stop),
    'Task' =>          %w(create show update destroy run stop),
    'Milestone' =>     %w(create show update destroy complete restart),
    'Tag' =>           %w(create show update destroy apply remove),
    'Upload' =>        %w(create show update destroy),
    'Import' =>        %w(create show update destroy),
    'Notification' =>  %w(create show update destroy),
    'CsvFile' =>       %w(create show update destroy)
  },
  

  'ApplicationAdministrator' => {
    'Events::Base' => %w(create show update destroy create_comment_on create_attachment_on),
    'ChorusScope' =>  %w(create show update destroy manage_scopes),
    'Role' =>         %w(create show update destroy manage_application_roles manage_workspace_roles),
    'User' =>         %w(create show update destroy change_password edit_dashboard manage_notifications manage_comments manage_notes manage_insights manage_data_source_credentials),
    'DataSourceAccount' =>      %w(create show update destroy change_password lock unlock),
    'Group' =>        %w(create show update destroy),
    'Workspace' =>    %w(create show update destroy admin edit_settings add_members delete_members add_to_scope remove_from_scope change_status explore_data transform_data download_data),
    'DataSource' =>   %w(create show update destroy add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data),
    'HdfsDataSource'=>%w(create show update destroy add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data),
    'GnipDataSource'=>%w(create show update destroy add_credentials edit_credentials delete_credentials add_data remove_data explore_data download_data),
    'Note' =>         %w(create show update destroy),
    'Schema' =>       %w(create show update destroy),
    'Sandbox' =>      %w(create show update destroy add_to_workspace delete_from_workspace),
    'Comment' =>      %w(create show update destroy promote_to_insight),
    'Workfile' =>     %w(create show update destroy run_workflow ),
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
  

  'ApplicationManager' => {
    'Events::Base' => %w(create_comment_on create_attachment_on),
    'ChorusScope' =>  %w(),
    'Role' =>         %w(manage_workspace_roles),
    'User' =>         %w(),
    'DataSourceAccount' =>      %w(),
    'Group' =>        %w(create show update destroy),
    'Workspace' =>    %w(create show update destroy admin edit_settings add_members delete_members add_to_scope remove_from_scope change_status explore_data transform_data download_data),
    'DataSource' =>   %w(create show update destroy add_data remove_data explore_data download_data),
    'HdfsDataSource'=>%w(create show update destroy add_data remove_data explore_data download_data),
    'GnipDataSource'=>%w(create show update destroy add_data remove_data explore_data download_data),
    'Note' =>         %w(create show update destroy),
    'Schema' =>       %w(show),
    'Sandbox' =>      %w(show),
    'Comment' =>      %w(create show update destroy promote_to_insight),
    'Workfile' =>     %w(),
    'Workflow' =>     %w(),
    'Job' =>          %w(),
    'Task' =>         %w(),
    'Milestone' =>    %w(),
    'Tag' =>          %w(create show update destroy apply remove),
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
    'DataSourceAccount' =>       %w(),
    'Group' =>         %w(),
    'Workspace' =>     %w(),
    'DataSource' =>    %w(),
    'HdfsDataSource'=> %w(),
    'GnipDataSource'=> %w(),
    'Note' =>          %w(),
    'Schema' =>        %w(),
    'Sandbox' =>       %w(),
    'Comment' =>       %w(),
    'Workfile' =>      %w(create create_workflow run_workflow),
    'Workflow' =>      %w(create show update destroy run stop open),
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
    'Events::Base' => %w(create show create_comment_on create_attachment_on),
    'ChorusScope' =>  %w(),
    'Role' =>         %w(),
    'User' =>         %w(),
    'DataSourceAccount' =>      %w(),
    'Group' =>        %w(),
    'Workspace' =>    %w(create show update edit_settings add_members delete_members add_to_scope remove_from_scope change_status explore_data transform_data download_data),
    'DataSource' =>   %w(),
    'HdfsDataSource'=>%w(),
    'GnipDataSource'=>%w(),
    'Note' =>         %w(create show update destroy),
    'Schema' =>       %w(),
    'Sandbox' =>      %w(),
    'Comment' =>      %w(create show update destroy promote_to_insight),
    'Workfile' =>     %w(create show update destroy run_workflow),
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
  
  'Contributor' => {
    'Events::Base' =>  %w(create show create_comment_on create_attachment_on),
    'ChorusScope' =>   %w(),
    'Role' =>          %w(),
    'User' =>          %w(),
    'DataSourceAccount' =>       %w(),
    'Group' =>         %w(),
    'Workspace' =>     %w(show explore_data transform_data download_data),
    'DataSource' =>    %w(),
    'HdfsDataSource'=> %w(),
    'GnipDataSource'=> %w(),
    'Note' =>          %w(create show),
    'Schema' =>        %w(),
    'Sandbox' =>       %w(),
    'Comment' =>       %w(create show promote_to_insight),
    'Workfile' =>      %w(create show),
    'Workflow' =>      %w(),
    'Job' =>           %w(create show update destroy run stop),
    'Task' =>          %w(create show update destroy run stop),
    'Milestone' =>     %w(),
    'Tag' =>           %w(create show update destroy apply remove),
    'Upload' =>        %w(create show update destroy),
    'Import' =>        %w(create show update destroy),
    'Notification' =>  %w(create show update destroy),
    'CsvFile' =>       %w(create show update destroy)
  },
  
  'ProjectDeveloper' => {
    'Events::Base' => %w(create show create_comment_on create_attachment_on),
    'ChorusScope' =>  %w(),
    'Role' =>         %w(),
    'User' =>         %w(),
    'DataSourceAccount' =>      %w(),
    'Group' =>        %w(),
    'Workspace' =>    %w(create show explore_data transform_data download_data),
    'DataSource' =>   %w(show explore_data download_data),
    'HdfsDataSource'=>%w(show explore_data download_data),
    'GnipDataSource'=>%w(show explore_data download_data),
    'Note' =>         %w(create show),
    'Schema' =>       %w(),
    'Sandbox' =>      %w(),
    'Comment' =>      %w(create show promote_to_insight),
    'Workfile' =>     %w(create show),
    'Workflow' =>     %w(create show update),
    'Job' =>          %w(create show update destroy run stop),
    'Task' =>         %w(create show update destroy run stop),
    'Milestone' =>    %w(),
    'Tag' =>          %w(create show update destroy apply remove),
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

# delete all previously stored permissions
Permission.destroy_all
role_permissions.each do |role_name, permissions_hash|
    role = Role.find_by_name(role_name)
    puts "---- Adding permissions for #{role_name} role ----"

    permissions_hash.each do |class_name, permission_names|
        chorus_class = ChorusClass.find_by_name(class_name)
        #puts "---- Adding permissions for #{role_name} role and #{class_name} ----"
        role.permissions << Permission.create(:role_id => role.id,
                                              :chorus_class_id => chorus_class.id, 
                                              :permissions_mask => create_permission_mask_for(permission_names, chorus_class.class_operations))
    end
end


puts ''
puts "===================== Migrating users to new roles =========================="
puts ''

User.find_in_batches({:batch_size => 100}) do |users|
  users.each do |user|
    if user.admin
      user.roles << admin_role unless user.roles.include? admin_role
      user.roles << app_manager_role unless user.roles.include? app_manager_role
    end
    if user.developer
      user.roles << workflow_developer_role unless user.roles.include? workflow_developer_role
    end
    user.roles << collaborator_role unless user.roles.include? collaborator_role
    user.roles << user_role unless user.roles.include? user_role
  end
end







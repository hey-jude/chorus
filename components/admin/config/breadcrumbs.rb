
 crumb :admin do
   link "Admin", admin.admin_index_path
 end

 crumb :admin_licence_info do
   link "Licence info", admin.licence_info_admin_index_path
   parent :admin
 end

 crumb :admin_email_config do
   link "Email Config", admin.email_config_admin_index_path
   parent :admin
 end

 crumb :admin_auth_config do
   link "Authentication Configuration", admin.auth_config_admin_index_path
   parent :admin
 end

 crumb :admin_general_settings do
   link "General Settings", admin.general_settings_admin_index_path
   parent :admin
 end

 crumb :admin_app_preferences do
   link "Application Preferences", admin.app_preferences_admin_index_path
   parent :admin
 end

 crumb :admin_default_settings do
   link "Default Settings", admin.default_settings_admin_index_path
   parent :admin
 end

 crumb :admin_app_preferences do
   link "Application Preferences", admin.app_preferences_admin_index_path
   parent :admin
 end

 crumb :admin_workflow_editor_pref do
   link "Workflow Editor Settings", admin.workflow_editor_pref_admin_index_path
   parent :admin
 end

 crumb :admin_manage_tags do
   link "Manage Tags", admin.manage_tags_admin_index_path
   parent :admin
 end

 crumb :users do
   link "People", admin.users_path
   parent :admin
 end

 crumb :user do |user|
   link user.first_name, admin.user_path
   parent :users
 end

 crumb :teams do
   link "Teams", admin.teams_path
   parent :admin
 end

 crumb :team do |team|
   link team.name, admin.team_path
   parent :teams
 end

 crumb :team_manage_members do |team|

 end
# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
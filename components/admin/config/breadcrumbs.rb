
 crumb :admin do
   link "Admin", admin.admin_index_path
 end

 crumb :users do
   link "People", admin.users_path , remote: true
   parent :admin
 end

 crumb :user do |user|
   link user.first_name, admin.user_path, remote: true
   parent :users
 end

 crumb :teams do
   link "Teams", admin.teams_path
   parent :admin
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
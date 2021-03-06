set :user, "root"
set :use_sudo, false
set :application, "54.183.47.47"
set :scm, 'git'
set :branch, "pt-fix-84142054"

set :scm_username, 'prakash-alpine'
set :scm_password, 'q2W#e4R%'
set :scm_verbose, true
set :repository,  "git@github.com:Chorus/chorus.git"
#set :repository, "https://ff-pteli:769cf08411b4fb028a209d768cddaf84f8abc061@github.com/FirstFuel/demo_firstengage.git"
set :shared, '../shared/chorus'

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

#set :deploy_to, "/home/#{user}/chorus"
set :deploy_to, "/usr/local/chorus"

#set :deploy_via, :export
#set :deploy_via, :copy
set :deploy_via, :remote_cache
default_run_options[:pty] = true
# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
ssh_options[:forward_agent] = true
#ssh_options[:auth_methods] = %w(password keyboard-interactive)
#ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "firstfuel-dev-prakash.pem")]
ssh_options[:keys] = "/Users/pmteli/.ssh/adl-performance.pem"

# =============================================================================
# You shouldn't have to modify the rest of these
# =============================================================================

role :web, application
role :app, application
role :db,  application, :primary => true

# set :deploy_to, "/home/#{user}/#{application}"
# set :svn, "/path/to/svn"       # defaults to searching the PATH
set :use_sudo, false

# additional settings
default_run_options[:pty] = true  # Forgo errors when deploying from windows
#ssh_options[:keys] = %w(/Path/To/id_rsa)            # If you are using ssh_keys
set :chmod755, "app config db lib public vendor script script/* public/disp*"



#desc "Task to symlink public and vendor folders"
#  task symlink_shared do
#    run "ln -nfs #{shared_path}/public #{release_path}/public"
#    run "ln -nfg #{shared_path}/vendor #{release_path}/vendor"
#  end

#after 'deploy:update_code', 'deploy:symlink_shared'

desc "Tasks to execute after code update"
after 'deploy:update_code', :roles => [:app, :db, :web] do
  # symlink public & vendor folders from shared
  run "chown -R chorus:chorus #{release_path}"
  #run "cp #{shared_path}/public/*.* #{release_path}/public"
  #run "cp #{shared_path}/public/dispatch.fcgi.production #{release_path}/public/dispatch.fcgi"
  #run "cp #{shared_path}/public/dispatch.cgi.production #{release_path}/public/dispatch.cgi"
  #run "cp #{shared_path}/public/dispatch.rb.production #{release_path}/public/dispatch.rb"
  run "cp #{release_path}/config/database.yml.production #{release_path}/config/database.yml"
  run "cp #{release_path}/config/environment.rb.production #{release_path}/config/environment.rb"
  #run "mv #{release_path}/public/index.html #{release_path}/public/index_3.html"
  #run "cp #{release_path}/config/deploy.rb.production #{release_path}/config/deploy.rb"
  #run "cp #{release_path}/config/settings.yml.production #{release_path}/config/settings.yml"
  #run "cp #{release_path}/config/initializers/application_constants.rb.production #{release_path}/config/initializers/application_constants.rb"
  #run "ln -nfs #{shared_path}/../../shared/uploads #{release_path}//public/uploads"
  #run "mkdir #{release_path}/tmp"
  #run "> #{release_path}/tmp/restart.txt"
  #run "cp #{release_path}/config/initializers/application_constants.rb.production #{release_path}/config/initializers/application_constants.rb"
  #run "cp #{release_path}/app/views/layouts/application.rhtml.production #{release_path}/app/views/layouts/application.rhtml"
  #run "cp #{release_path}/config/gmaps_api_key.yml.production #{release_path}/config/gmaps_api_key.yml"
  #run "cp #{shared_path}/public/.htaccess #{release_path}/public/."
  run "ln -nfs #{shared_path}/demo_data #{release_path}/demo_data"
  run "ln -nfs #{shared_path}/postgres-db #{release_path}/db"
  run "rm -rf #{release_path}/tmp"
  run "ln -nfs #{shared_path}/tmp #{release_path}/tmp"
  run "rm -rf #{release_path}/log"
  run "ln -nfs #{shared_path}/log #{release_path}/log"
  run "rm -rf #{release_path}/system"
  run "ln -nfs #{shared_path}/system #{release_path}/system"
  run "ln -nfs #{shared_path}/bin #{release_path}/bin"

  upload "./config/secret.key",  "#{release_path}/config/secret.key"
  upload "./config/secrets.yml", "#{release_path}/config/secrets.yml"

  run "cp #{shared_path}/vendor/jruby.jar #{release_path}/vendor/."
  run "cp #{shared_path}/vendor/jruby-rack.jar #{release_path}/vendor/."
  run "cp -r #{shared_path}/vendor/jetty #{release_path}/vendor/jetty"


  #run "ln -nfs #{shared_path}/public/images #{release_path}/public/images"
  #run "ln -nfs #{shared_path}/public/assets #{release_path}/public/assets"
  #run "ln -nfs #{shared_path}/vendor/assets #{release_path}/vendor/assets"
  #run "ln -nfs #{shared_path}/app/assets #{release_path}/app/assets"
  #run "ln -nfs #{shared_path}/public/javascripts #{release_path}/public/javascripts"
  #run "ln -nfs #{shared_path}/public/stylesheets #{release_path}/public/stylesheets"
  #run "ln -nfs #{shared_path}/public/uploads #{release_path}/public/uploads"
  #run "ln -nfs #{shared_path}/public/swf #{release_path}/public/swf"
  #run "ln -nfs #{shared_path}/public/cache #{release_path}/public/cache"
  #run "ln -nfs #{shared_path}/public/channel #{release_path}/public/channel"
  #run "ln -nfs #{shared_path}/public/new_channel #{release_path}/public/new_channel"
  #run "ln -nfs #{shared_path}/vendor #{release_path}/vendor"
  # fix permissions
  #run "chmod +x #{release_path}/script/process/reaper"
  #run "chmod 755 #{release_path}/public/uploads/photos/*.JPG"
  #run "chmod +x #{release_path}/script/process/spawner"
  #run "cd #{release_path}"
  #run "rake assets:precompile RAILS_ENV=production"
  #run "chmod 755 #{release_path}/public/dispatch.*"
end


namespace :app do
  task :public_assets do
    #run "mkdir #{latest_release}/public/assets"
    #upload "./public/404.html", "#{latest_release}/public/404.html", :via => :scp
    upload "./public/assets/",  "#{latest_release}/public", :via=> :scp, :recursive => true
    #upload "./public/downloads/",  "#{latest_release}/public", :via=> :scp, :recursive => true
    #upload "./public/index.html",  "#{latest_release}/public", :via=> :scp
  end

  task :rails_app  do
    #run "mkdir #{latest_release}/public/assets"
    #upload "./app/controllers/*",  "/usr/local/chorus/current/app/controllers/*", :via=> :scp, :recursive => true
    #upload "./app/presenters/*",  "/usr/local/chorus/current/app/presenters/*", :via=> :scp, :recursive => true
    #upload "./app/models",  "/usr/local/chorus/current/app/models", :via=> :scp, :recursive => true
    #upload "./app/views",  "/usr/local/chorus/current/app/views", :via=> :scp, :recursive => true

    system "rsync -ru -e 'ssh -i /Users/pmteli/.ssh/adl-performance.pem' --exclude='.DS_Store' ./app/controllers #{user}@#{application}:/usr/local/chorus/current/app"
    system "rsync -ru -e 'ssh -i /Users/pmteli/.ssh/adl-performance.pem' --exclude='.DS_Store' ./app/models #{user}@#{application}:/usr/local/chorus/current/app"
    system "rsync -ru -e 'ssh -i /Users/pmteli/.ssh/adl-performance.pem' --exclude='.DS_Store' ./app/views #{user}@#{application}:/usr/local/chorus/current/app"
    system "rsync -ru -e 'ssh -i /Users/pmteli/.ssh/adl-performance.pem' --exclude='.DS_Store' ./app/helpers #{user}@#{application}:/usr/local/chorus/current/app"
    system "rsync -ru -e 'ssh -i /Users/pmteli/.ssh/adl-performance.pem' --exclude='.DS_Store' ./app/mixins #{user}@#{application}:/usr/local/chorus/current/app"
    system "rsync -ru -e 'ssh -i /Users/pmteli/.ssh/adl-performance.pem' --exclude='.DS_Store' ./app/services #{user}@#{application}:/usr/local/chorus/current/app"
    system "rsync -ru -e 'ssh -i /Users/pmteli/.ssh/adl-performance.pem' --exclude='.DS_Store' ./app/validators #{user}@#{application}:/usr/local/chorus/current/app"
    run "chown -R chorus:chorus /usr/local/chorus/current/app"
    system "rsync -ru -e 'ssh -i /Users/pmteli/.ssh/adl-performance.pem' --exclude='.DS_Store' ./app/presenters #{user}@#{application}:/usr/local/chorus/current/app"
    system "rsync -ru -e 'ssh -i /Users/pmteli/.ssh/adl-performance.pem' --exclude='.DS_Store' ./lib/tasks #{user}@#{application}:/usr/local/chorus/current/lib"
    run "chown -R chorus:chorus /usr/local/chorus/current/lib"
    #upload "./public/downloads/",  "#{latest_release}/public", :via=> :scp, :recursive => true
    #upload "./public/index.html",  "#{latest_release}/public", :via=> :scp
    run "> #{latest_release}/tmp/restart.txt"
  end

end

namespace :deploy do

#    desc "Task to sync public & vendor folders on remote servers. Run this task only when the content of the public & vendor folder is changed."
# task :public_assets do
#      system "rsync -vr --exclude='.DS_Store' #{shared}/public #{user}@#{application}:#{shared_path}"
#  end

  task :vendor_assets do
    system "rsync -vr --exclude='.DS_Store' #{shared}/vendor #{user}@#{application}:#{shared_path}"
  end
  task :app_assets do
    system "rsync -vr --exclude='.DS_Store' #{shared}/app #{user}@#{application}:#{shared_path}"
  end

  task :restart do
    run "> #{latest_release}/tmp/restart.txt"

  end

end

desc "Restarting after deployment"
task :after_deploy, :roles => [:app, :db, :web] do
  run "touch #{release_path}/tmp/restart.txt"
  #run "/home/#{user}/#{application}/current/script/process/reaper --dispatcher=dispatch.fcgi"
  #run "touch /home/#{user}/#{application}/current/public/dispatch.fcgi"
end

desc "Restarting after rollback"
task :after_rollback, :roles => [:app, :db, :web] do
  #run "/home/#{user}/#{application}/current/script/process/reaper --dispatcher=dispatch.fcgi"
  #run "touch /home/#{user}/#{application}/current/public/dispatch.fcgi"
end


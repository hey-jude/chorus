module PermissionsUtils
  def self.should_migrate_permissions?
    user_class = ChorusClass.where(:name => 'user'.camelize).first
    workspace_class = ChorusClass.where(:name => 'workspace'.camelize).first
    datasource_class = ChorusClass.where(:name => 'data_source'.camelize).first

    if user_class.nil? || workspace_class.nil? || datasource_class.nil?
      $stderr.puts "Error: rake db:seed_permissions must be run before rake db:migrate_permissions"
      return true
    end

    user_co_count = ChorusObject.where(:chorus_class_id => user_class.id).count
    ws_co_count = ChorusObject.where(:chorus_class_id =>  workspace_class.id).count
    datasource_co_count = ChorusObject.where(:chorus_class_id => datasource_class.id).count


    user_co_count != User.count || ws_co_count != Workspace.count || datasource_co_count != DataSource.count
  end


  def self.running_webserver?
    ['mizuno', 'jetty'].include? File.split($0).last
  end

  def self.check_permissions_migration_status
    if running_webserver? && should_migrate_permissions?
      abort("\nError: 'packaging/chorus_control.sh migrate' must be run before starting Chorus. Press ctrl+c to exit\n")
    end
  end
end
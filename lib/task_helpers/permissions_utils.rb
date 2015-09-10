module PermissionsUtils

  def self.should_migrate_permissions?
    user_class = ChorusClass.where(:name => 'user'.camelize).first
    workspace_class = ChorusClass.where(:name => 'workspace'.camelize).first
    datasource_class = ChorusClass.where(:name => 'data_source'.camelize).first

    user_co_count = ChorusObject.where(:chorus_class_id => user_class.id).count
    ws_co_count = ChorusObject.where(:chorus_class_id =>  workspace_class.id).count
    datasource_co_count = ChorusObject.where(:chorus_class_id => datasource_class.id).count

    user_co_count != User.count || ws_co_count != Workspace.count || datasource_co_count != DataSource.count
  end

  def self.should_seed_permissions?

    user_class = ChorusClass.where(:name => 'user'.camelize).first
    workspace_class = ChorusClass.where(:name => 'workspace'.camelize).first
    datasource_class = ChorusClass.where(:name => 'data_source'.camelize).first

    user_class.nil? || workspace_class.nil? || datasource_class.nil?

  end

  def self.running_webserver?
    ['mizuno', 'jetty'].include? File.split($0).last
  end

  def self.check_permissions_migration_status

    if running_webserver?
      if should_seed_permissions?
         $stderr.puts ''
         $stderr.puts '====================================================================================================================='
         abort("Error: 'packaging/chorus_control.sh migrate' must be run before starting Chorus. Press ctrl+c to exit\n")
       end

      if should_migrate_permissions?
        $stderr.puts ''
        $stderr.puts '======================================================================================================================'
        abort("Error: 'packaging/chorus_control.sh migrate' must be run before starting Chorus. Press ctrl+c to exit\n")
      end
    end

  end

end

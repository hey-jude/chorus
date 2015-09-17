class PermissionsMigrator

  CLASSES = [
      'Events::Base',
      'ChorusScope',
      'Role',
      'User',
      'DataSourceAccount',
      'Group',
      'Workspace',
      'DataSource',
      'HdfsDataSource',
      'GnipDataSource',
      'JdbcHiveDataSource',
      'Schema',
      'Comment',
      'Workfile',
      'Job',
      'Milestone',
      'Tag',
      'Upload',
      'Import',
      'Notification',
      'CsvFile',
      'Database',
      'Dataset'
  ]

  def self.migrate_5_7
    insert_chorus_object_rows
    assign_workspace_roles
    assign_users_to_default_group
  end

  private

  def self.insert_chorus_object_rows
    CLASSES.map(&:constantize).each do |klass|
      rows = create_rows(klass)

      ChorusObject.connection.execute "INSERT INTO chorus_objects #{attribute_columns_string} VALUES #{rows.join(", ")}" if rows.any?
    end
  end

  def self.create_rows(klass)
    chorus_class_id = ChorusClass.where(:name => klass.name).pluck(:id).first
    scope_id = ChorusScope.where(:name => 'application_realm').pluck(:id).first
    time = Time.now.to_s(:db)

    klass.all.map do |object|
      create_attribte_string(object, chorus_class_id, time, scope_id)
    end
  end

  def self.assign_workspace_roles
    project_manager_role = Role.where(:name => 'ProjectManager').first
    owner_role = Role.where(:name => 'Owner').first

    Workspace.all.each do |ws|
      ws.add_user_to_object_role(ws.owner, owner_role)

      ws.members.each do |member|
        ws.add_user_to_object_role(member, project_manager_role)
      end
    end
  end

  def self.create_attribte_string(object, chorus_class_id, time, scope_id)

    if object.respond_to? :owner_id
      object_owner = object.owner_id
    else
      object_owner = "NULL"
    end

    "(#{chorus_class_id}, #{object.id}, #{object_owner}, '#{time}', '#{time}', #{scope_id})"
  end

  def self.attribute_columns_string
    "(chorus_class_id, instance_id, owner_id, created_at, updated_at, chorus_scope_id)"
  end

  def self.assign_users_to_default_group
    default_group = Group.find_or_create_by_name(:name => 'default_group')

    User.all.each{ |user| user.groups << default_group }
  end
end

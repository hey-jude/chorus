class PermissionsMigrator

  CLASSES = [
      Events::Base,
      ChorusScope,
      Role,
      User,
      DataSourceAccount,
      Group,
      Workspace,
      DataSource,
      HdfsDataSource,
      GnipDataSource,
      JdbcHiveDataSource,
      Schema,
      Comment,
      Workfile,
      Job,
      Milestone,
      Tag,
      Upload,
      Import,
      Notification,
      CsvFile,
      Database,
      Dataset
  ]

  def self.migrate_5_7
    insert_chorus_object_rows
    assign_workspace_roles
    assign_users_to_default_group
  end

  #private

  def self.insert_chorus_object_rows
    CLASSES.each do |klass|
      rows = create_rows(klass)

      ChorusObject.connection.execute "INSERT INTO chorus_objects #{attribute_columns_string} VALUES #{rows.join(", ")}" if rows.any?
    end
  end

  def self.create_rows(klass)
    scope_id = ChorusScope.where(:name => 'application_realm').first.id
    modified_at = Time.now.to_s(:db)

    klass.all.map do |object|
      chorus_class_id = ChorusClass.where(:name => object.class.name).first.try(:id)
      unless chorus_class_id
        raise "Whoops! #{object} has no ChorusClass.  seed_permissions.rb didn't create all the necessary classes. Please re-run rake db:seed_permissions"
      end
      create_attribute_string(object, chorus_class_id, modified_at, scope_id)
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

  def self.create_attribute_string(object, chorus_class_id, modified_at, scope_id)

    if object.respond_to? :owner_id
      object_owner = object.owner_id
    else
      object_owner = "NULL"
    end

    "(#{chorus_class_id}, #{object.id}, #{object_owner}, '#{modified_at}', '#{modified_at}', #{scope_id})"
  end

  def self.attribute_columns_string
    "(chorus_class_id, instance_id, owner_id, created_at, updated_at, chorus_scope_id)"
  end

  def self.assign_users_to_default_group
    default_group = Group.where(:name => 'default_group').first_or_create

    User.all.each{ |user| user.groups << default_group unless user.groups.include?(default_group) }
  end
end

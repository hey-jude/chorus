require 'spec_helper'

describe 'migrate_permissions' do

  before :each do
    ChorusObject.delete_all
  end


  # NOTE: most tests will re-run the functionality in question for every assertion.
  # This migration script takes a long time so we only run it once and check everything
  # in this method.
  it "should create the right number of chorus objects" do

    PermissionsMigrator.migrate_5_7

    KLASSES = [
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

    # ChorusObject assertions

    KLASSES.each do |klass_name|
      chorus_class_id = ChorusClass.where(:name => klass_name).first.id

      # Uncomment these lines for debugging purposes
      #puts "class: #{klass_name}"
      #puts "ChorusObject count: #{ChorusObject.where(:chorus_class_id => chorus_class_id).count}"
      #puts "class        count: #{klass_name.constantize.count}"
      #puts ""

      expect(ChorusObject.where(:chorus_class_id => chorus_class_id).count).to eq(klass_name.constantize.count)
    end

    # Workspace Roles assertions

    project_manager_role = Role.where(:name => 'ProjectManager').first
    owner_role = Role.where(:name => 'Owner').first

    Workspace.all.each do |ws|
      expect(ws.roles_for_user(ws.owner)).to include(project_manager_role, owner_role)
      expect(ws.users_for_role(project_manager_role)).to include(*ws.members)
    end


    # Scope assertions
    expect(ChorusObject.where(:chorus_scope_id => nil).count).to eq(0)
  end
end

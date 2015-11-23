# Monkeypatch fixture builder to be able to customize the "fixtures_dir" ...
module FixtureBuilder
  class Configuration
    def fixtures_dir(path = '')
      File.expand_path(File.join(Authorization::Engine.root, 'spec', 'fixtures', path))
    end
  end
end

FixtureBuilder.configure do |fbuilder|
  # rebuild fixtures automatically when these files change:
  fbuilder.files_to_check += Dir[*%w{
    spec/support/fixture_builder.rb
    spec/factories/*
  }]

  fbuilder.factory do
    Sunspot.session = SunspotMatchers::SunspotSessionSpy.new(Sunspot.session)

    load "#{Authorization::Engine.root}/db/permissions_seeds.rb"

    #Roles, Groups, and Permissions
    @a_role = FactoryGirl.create(:role)
    @a_permission = FactoryGirl.create(:permission)
    @a_group = FactoryGirl.create(:group)

    fbuilder.name(:admin,
                  admin = FactoryGirl.create(:admin, {:last_name => 'AlphaSearch', :username => 'admin'})
    )


    fbuilder.name(:evil_admin,
                  evil_admin = FactoryGirl.create(:admin, {:last_name => 'AlphaSearch', :username => 'evil_admin'})
    )

    fbuilder.name(:default,
                  FactoryGirl.create(:user, :username => 'default'))

    fbuilder.name(:the_collaborator,
                  the_collaborator = FactoryGirl.create(:user, :username => 'the_collaborator'))

    fbuilder.name(:no_collaborators,
                  no_collaborators = FactoryGirl.create(:user, :username => 'no_collaborators'))

    fbuilder.name(:owner,
                  owner = FactoryGirl.create(:user, :first_name => 'searchquery', :username => 'owner',
                                             :image => Rack::Test::UploadedFile.new(Pathname.new(ENV['CHORUS_HOME']).join('spec', 'fixtures', 'files', 'User.png'), "image/png"))
    )

    fbuilder.name(:not_a_member,
                  not_a_member = FactoryGirl.create(:user, :username => 'not_a_member')
    )

    gpdb_data_source = FactoryGirl.create(:gpdb_data_source, :name => "searchquery", :description => "Just for searchquery and greenplumsearch", :host => "non.legit.example.com", :port => "5432", :db_name => "postgres", :owner => admin)
    fbuilder.name :default, gpdb_data_source

    owners_data_source = FactoryGirl.create(:gpdb_data_source, :name => "Owners", :owner => owner, :shared => false)

    oracle_data_source = FactoryGirl.create(:oracle_data_source, name: 'oracle', owner: owner)
    fbuilder.name(:oracle, oracle_data_source)

    pg_data_source = FactoryGirl.create(:pg_data_source, :name => 'postgres', :owner => owner)
    pg_database = FactoryGirl.create(:pg_database, :name => 'pg', :data_source => pg_data_source)

    hdfs_data_source = HdfsDataSource.create!({:name => 'searchquery_hadoop', :description => 'searchquery for the hadoop data source', :host => 'hadoop.example.com', :port => '1111', :owner => admin, :hdfs_version => 'Pivotal HD 3'}, :without_protection => true)
    fbuilder.name :hadoop, hdfs_data_source

    gnip_data_source = FactoryGirl.create(:gnip_data_source, :owner => owner, :name => "default", :description => "a searchquery example gnip account")

    default_database = FactoryGirl.create(:gpdb_database, :data_source => owners_data_source, :name => 'default')
    default_schema = FactoryGirl.create(:gpdb_schema, :name => 'default', :database => default_database)
    FactoryGirl.create(:gpdb_schema, :name => "public", :database => default_database)
    default_table = FactoryGirl.create(:gpdb_table, :name => "default_table", :schema => default_schema, :skip_search_index => true)

    searchquery_database = FactoryGirl.create(:gpdb_database, :data_source => owners_data_source, :name => 'searchquery_database')
    searchquery_schema = FactoryGirl.create(:gpdb_schema, :name => "searchquery_schema", :database => searchquery_database)
    searchquery_table = FactoryGirl.create(:gpdb_table, :name => "searchquery_table", :schema => searchquery_schema)


    workspaces = []

    workspaces << no_collaborators_public_workspace = no_collaborators.owned_workspaces.create!(:name => "Public with no collaborators except collaborator", :summary => 'searchquery can see I guess', :public => true)
    @public_with_no_collaborators = no_collaborators_public_workspace
    workspaces << no_collaborators_private_workspace = no_collaborators.owned_workspaces.create!(:name => "Private with no collaborators", :summary => "Not for searchquery, ha ha", :public => false)

    workspaces << public_workspace = owner.owned_workspaces.create!({:name => "Public", :summary => "searchquery", :sandbox => default_schema, :public => true, :is_project => true}, :without_protection => true)
    workspaces << private_workspace = owner.owned_workspaces.create!(:name => "Private", :summary => "searchquery", :public => false)

    fbuilder.name :public, public_workspace

    @hdfs_file = FactoryGirl.create(:hdfs_entry, :path => '/foo/bar/baz.sql', :hdfs_data_source => hdfs_data_source)
    @directory = FactoryGirl.create(:hdfs_entry, :path => '/data', :hdfs_data_source => hdfs_data_source, :is_directory => true)

    File.open(Pathname.new(ENV['CHORUS_HOME']).join('spec', 'fixtures', 'files', 'workfile.sql')) do |file|
      no_collaborators_private = FactoryGirl.create(:chorus_workfile, :file_name => "no collaborators Private", :description => "searchquery", :owner => no_collaborators, :workspace => no_collaborators_private_workspace, :versions_attributes => [{:contents => file}])

      fbuilder.name(:public,
                    public_workfile = FactoryGirl.create(:chorus_workfile, :file_name => "Public", :description => "searchquery", :owner => owner, :workspace => public_workspace, :versions_attributes => [{:contents => file}])
      )

      Thread.current[:user] = owner
      @note_on_no_collaborators_private_workfile = Events::NoteOnWorkfile.create!({:note_target => no_collaborators_private, :body => 'notesearch never'}, :as => :create)
      Thread.current[:user] = nil

    end

    csv_file_owner = CsvFile.new({:user => owner, :workspace => public_workspace, :column_names => [:id], :types => [:integer], :delimiter => ',', :has_header => true, :to_table => 'table', :new_table => true, :contents_file_name => 'import.csv'}, :without_protection => true)
    csv_file_owner.save!(:validate => false)
    fbuilder.name :default, csv_file_owner


    default_upload = FactoryGirl.create(:upload, :user => the_collaborator)
    fbuilder.name :default, default_upload


    Thread.current[:user] = owner
    @note_on_greenplum = Events::NoteOnDataSource.create!({:note_target => gpdb_data_source, :body => 'i am a comment with greenplumsearch in me'}, :as => :create)

    @note_on_workspace = Events::NoteOnWorkspace.create!({:note_target => public_workspace, :body => 'Come see my awesome workspace!'}, :as => :create)

    @note_on_dataset = Events::NoteOnDataset.create!({:dataset => searchquery_table, :body => 'notesearch ftw'}, :as => :create)

    Thread.current[:user] = nil

    Thread.current[:user] = no_collaborators
    @note_on_no_collaborators_private = Events::NoteOnWorkspace.create!({:note_target => no_collaborators_private_workspace, :body => 'notesearch never'}, :as => :create)
    Thread.current[:user] = nil

    second_comment_on_note_on_greenplum = Comment.create!({:body => "2nd Comment on Note on Greenplum", :event_id => @note_on_greenplum.id, :author_id => the_collaborator.id})
    fbuilder.name :second_comment_on_note_on_greenplum, second_comment_on_note_on_greenplum

    Events::MembersAdded.by(owner).add(:workspace => public_workspace, :member => the_collaborator, :num_added => 5)

    @attachment_workspace = @note_on_workspace.attachments.create!(:contents => File.new(Pathname.new(ENV['CHORUS_HOME']).join('spec', 'fixtures', 'files', 'searchquery_workspace')))
    @attachment_private_workspace = @note_on_no_collaborators_private.attachments.create!(:contents => File.new(Pathname.new(ENV['CHORUS_HOME']).join('spec', 'fixtures', 'files', 'searchquery_workspace')))

    notes = Events::NoteOnDataSource.by(owner).order(:id)

    @notification1 = Notification.create!({:recipient => owner, :event => notes[0], :comment => second_comment_on_note_on_greenplum}, :without_protection => true)

    ChorusObject.all.each do |co|
      co.chorus_scope = ChorusScope.where(:name => "application_realm").first
      co.save!
    end

    # HDFS Datasets need a workspace association
    attrs = FactoryGirl.attributes_for(:hdfs_dataset, :name => "hadoop", :hdfs_data_source => hdfs_data_source, :workspace => public_workspace)
    hadoop_dadoop = HdfsDataset.assemble!(attrs, hdfs_data_source, public_workspace)

    load "#{Authorization::Engine.root}/db/permissions_migrator.rb"
    PermissionsMigrator.assign_users_to_default_group

    Sunspot.session = Sunspot.session.original_session if Sunspot.session.is_a? SunspotMatchers::SunspotSessionSpy
    #Nothing should go ↓ here.  Resetting the sunspot session should be the last thing in this file.
  end
end

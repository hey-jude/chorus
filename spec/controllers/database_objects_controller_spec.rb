require 'spec_helper'

describe DatabaseObjectsController do
  let(:user) { FactoryGirl.create :user}

  before do
    log_in user
  end

  context "#index" do
    let(:instance) { FactoryGirl.create(:instance, :owner_id => user.id) }
    let(:instanceAccount) { FactoryGirl.create(:instance_account, :instance_id => instance.id, :owner_id => user.id) }

    let(:database) { FactoryGirl.create(:gpdb_database, :instance => instance, :name => "database1") }
    let(:schema) { FactoryGirl.create(:gpdb_schema, :name => 'schema1', :database => database) }
    let!(:table) { FactoryGirl.create(:gpdb_table, :name => 'table1', :schema => schema) }
    let!(:view) { FactoryGirl.create(:gpdb_view, :name => 'view1', :schema => schema) }

    before do
      stub(GpdbDatabaseObject).refresh(instanceAccount, schema) { [] }
    end

    it "should retrieve all db objects for a schema" do
      get :index, :schema_id => schema.to_param

      response.code.should == "200"
      decoded_response.length.should == 2

      decoded_response[0].id.should == table.id
      decoded_response[1].id.should == view.id
    end

    it "should not return db objects in another schema" do
      different_table = FactoryGirl.create(:gpdb_table)
      get :index, :schema_id => schema.to_param
      decoded_response.map(&:id).should_not include different_table.id
    end

    it "should paginate results" do
      get :index, :schema_id => schema.to_param, :per_page => 1
      decoded_response.length.should == 1
    end

    it "should sort db objects by name" do
      FactoryGirl.create(:gpdb_table, :name => 'aaaa', :schema => schema)
      get :index, :schema_id => schema.to_param
      decoded_response.first.object_name.should == 'aaaa'
    end
  end
end

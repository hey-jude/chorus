require 'spec_helper'

describe DatabaseSchemasController do

  let(:user) { users(:owner) }

  before do
    log_in user
    #
    stub(Authority).authorize!.with_any_args { nil }
  end

  describe "#index" do
    let(:gpdb_data_source) { data_sources(:owners) }
    let(:database) { databases(:default) }
    let(:schema1) { database.schemas[0] }
    let(:schema2) { database.schemas[1] }

    it_behaves_like "a scoped endpoint" do
      let!(:klass) { Schema }
      let!(:user)  { users(:owner) }
      let!(:action){ :index }
      let!(:params){ { :database_id => database.to_param } }
    end

    before do
      stub(Schema).refresh(gpdb_data_source.account_for_user!(user), database) { [schema1, schema2] }
    end

    it 'uses authorization' do
      mock(Authority).authorize!(:explore_data, gpdb_data_source, user, { :or => [:data_source_is_shared, :data_source_account_exists] })
      get :index, :database_id => database.to_param
    end

    it 'retrieves all schemas for a database' do
      get :index, :database_id => database.to_param

      response.code.should == "200"
      decoded_response.should have(2).items

      decoded_response[0].name.should == schema1.name
      decoded_response[0].database.data_source.id.should == gpdb_data_source.id
      decoded_response[0].database.name.should == schema1.database.name
      decoded_response[0].dataset_count.should == schema1.active_tables_and_views_count

      decoded_response[1].name.should == schema2.name
      decoded_response[1].database.data_source.id.should == gpdb_data_source.id
      decoded_response[1].database.name.should == schema2.database.name
      decoded_response[1].dataset_count.should == schema2.active_tables_and_views_count
    end

    it_behaves_like "a paginated list" do
      let(:params) {{ :database_id => database.to_param }}
    end

    generate_fixture "schemaSet.json" do
      get :index, :database_id => database.to_param
    end
  end
end

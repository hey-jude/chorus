require 'spec_helper'

describe Api::DatabasesController do
  routes { Api::Engine.routes }

  let(:user) { users(:owner) }

  before do
    log_in user
    stub(Authorization::Authority).authorize!.with_any_args { nil }
  end

  describe "#index" do
    it "fails when no such gpdb data source" do
      get :index, :data_source_id => 12345
      response.code.should == "404"
    end

    context "when the data source is accessible" do
      let(:gpdb_data_source) { data_sources(:shared) }
      let(:database) { databases(:shared_database) }
      let(:database2) { databases(:shared_database) }

      it_behaves_like "a scoped endpoint" do
        before do
          stub(Database).refresh { [database] }
        end
        let!(:klass) { Database }
        let!(:user)  { users(:owner) }
        let!(:action){ :index }
        let!(:params){ { :data_source_id => gpdb_data_source.id } }
      end

      it "checks authorization" do
        stub(Database).refresh { [database] }
        mock(Authorization::Authority).authorize!(:explore_data, gpdb_data_source, user, { :or => [:data_source_is_shared, :data_source_account_exists] })

        get :index, :data_source_id => gpdb_data_source.id
      end

      context "when the refresh of the db fails" do
        before do
          stub(Database).refresh { raise ActiveRecord::JDBCError.new }
        end

        it "should fail" do
          get :index, :data_source_id => gpdb_data_source.id
          response.code.should == "422"
        end
      end

      context "when refresh of the db succeeds" do
        before do
          stub(Database).refresh { [database, database2] }
        end

        it "should succeed" do
          get :index, :data_source_id => gpdb_data_source.id
          response.code.should == "200"
          decoded_response[0].id.should == database.id
          decoded_response[0].data_source.id.should == gpdb_data_source.id
          decoded_response.size.should == 2
        end

        it_behaves_like "a paginated list" do
          let(:params) {{ :data_source_id => gpdb_data_source.id }}
        end
      end
    end

    context 'when it is a postgres data source' do
      let(:data_source) { data_sources(:postgres) }
      let(:database) { databases(:pg) }

      before do
        stub(Database).refresh { [database] }
      end

      it 'should succeed' do
        get :index, :data_source_id => data_source.id
        response.code.should == '200'
        decoded_response[0].id.should == database.id
        decoded_response[0].data_source.id.should == data_source.id
        decoded_response.size.should == 1
      end

      it "should be forbidden if the data source is disabled" do
        data_source.update_attributes(:state => 'disabled')
        get :index, :data_source_id => data_source.id

        response.should be_forbidden
      end

      it_behaves_like 'a paginated list' do
        let(:params) {{ :data_source_id => data_source.id }}
      end
    end
  end

  describe "#show" do
    let(:database) { databases(:default) }

    it "uses authorization" do
      mock(Authorization::Authority).authorize!(:explore_data, database.data_source, user, { :or => [:data_source_is_shared, :data_source_account_exists] })

      get :show, :id => database.to_param
    end

    it "renders the database" do
      get :show, :id => database.to_param
      response.code.should == "200"
      decoded_response.data_source.id.should == database.data_source.id
      decoded_response.data_source.name.should == database.data_source.name
      decoded_response.id.should == database.id
      decoded_response.name.should == database.name
    end

    context 'generating fixtures' do
      let(:pg_database) { databases(:pg) }

      generate_fixture 'database.json' do
        get :show, :id => database.to_param
      end

      generate_fixture 'pgDatabase.json' do
        get :show, :id => pg_database.to_param
      end
    end


    context "when the db can't be found" do
      it "returns 404" do
        get :show, :id => "-1"
        response.code.should == "404"
      end
    end

    context "when the current user does not have credentials for the data source" do
      let(:user) { users(:default) }
      subject { described_class.new }

      generate_fixture "forbiddenDataSource.json" do
        stub(Authorization::Authority).authorize! { raise Authorization::AccessDenied.new("Forbidden", :activity, database) }
        get :show, :id => database.to_param
        response.should be_forbidden
      end
    end
  end
end
require 'spec_helper'

describe Api::AnalyzeController do
  routes { Api::Engine.routes }

  let(:user) { users(:the_collaborator) }
  let(:gpdb_table) { datasets(:default_table) }
  let(:gpdb_data_source) { gpdb_table.data_source }
  let(:account) { gpdb_data_source.account_for_user!(user) }

  before do
    log_in user
    #
    stub(Authorization::Authority).authorize!.with_any_args { nil }
  end

  describe "#create" do
    before do
      fake_result = GreenplumSqlResult.new
      any_instance_of(GpdbTable) do |gpdb_table|
        stub(gpdb_table).analyze(account) { fake_result }
      end
    end

    it "uses authentication" do
      mock(Authorization::Authority).authorize! :explore_data, gpdb_table.data_source, user, { :or => [:data_source_is_shared, :data_source_account_exists] }
      post :create, :table_id => gpdb_table.to_param
    end

    it "reports that the Analyze was created" do
      post :create, :table_id => gpdb_table.to_param
      response.code.should == "200"
    end
  end
end

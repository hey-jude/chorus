require 'spec_helper'

describe Api::SchemasController do
  routes { Api::Engine.routes }

  let(:user) { users(:owner) }

  before do
    log_in user
    #
    stub(Authorization::Authority).authorize!.with_any_args { nil }
  end

  describe "#show" do
    let(:schema) { schemas(:default) }

    before do
      stub(Schema).find(schema.to_param) { schema }
      stub(schema).verify_in_source { true }
    end

    it "uses authorization" do
      mock(Authorization::Authority).authorize!(:explore_data, schema.data_source, user, { :or => [:data_source_is_shared, :data_source_account_exists] })
      get :show, :id => schema.to_param
    end

    it "renders the schema" do
      get :show, :id => schema.to_param
      response.code.should == "200"
      decoded_response.id.should == schema.id
    end

    it "verifies the schema exists" do
      mock(schema).verify_in_source(user) { true }
      get :show, :id => schema.to_param
      response.code.should == "200"
    end

    context "when the schema can't be found" do
      it "returns 404" do
        stub(Schema).find("-1") { raise ActiveRecord::RecordNotFound.new }

        get :show, :id => "-1"
        response.code.should == "404"
      end
    end

    context "when the schema is not in data source" do
      it "should raise an error" do
        stub(schema).verify_in_source(user) { raise ActiveRecord::RecordNotFound.new }
        get :show, :id => schema.to_param

        response.code.should == "404"
      end
    end

    context "when the user does not have an account for the Data Source" do
      it "returns a 403" do
        mock(Authorization::Authority).authorize!.with_any_args {
          raise Authorization::AccessDenied.new("Forbidden", :activity, schema)
        }

        get :show, :id => schema.to_param
        response.code.should == "403"
      end
    end

    generate_fixture "schema.json" do
      get :show, :id => schema.to_param
    end

    context "for an Oracle Schema" do
      let(:schema) { schemas(:oracle) }

      generate_fixture "oracleSchema.json" do
        log_in users(:the_collaborator)
        get :show, :id => schema.to_param
      end
    end

    context 'for a Postgres Schema' do
      let(:schema) { schemas(:pg) }

      generate_fixture 'pgSchema.json' do
        log_in users(:the_collaborator)
        get :show, :id => schema.to_param
      end
    end
  end
end

require 'spec_helper'

describe Api::FunctionsController do
  routes { Api::Engine.routes }

  let(:user) { users(:owner) }

  before do
    log_in user
    stub(Authority).authorize!.with_any_args { nil }
  end

  describe "#index" do
    let(:schema) { schemas(:default) }

    context 'for a gpdb schema' do
      it "should check for permissions" do
        mock(Authority).authorize! :explore_data, schema.data_source, user,  { :or => [:data_source_is_shared, :data_source_account_exists] }
        get :index, :schema_id => schema.to_param
      end
    end
  end
end
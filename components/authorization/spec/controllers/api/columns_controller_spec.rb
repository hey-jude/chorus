require 'spec_helper'

describe Api::ColumnsController do
  routes { Api::Engine.routes }

  before do
    log_in user
    stub(Authorization::Authority).authorize!.with_any_args { nil }
  end

  context '#index' do

    context 'with mock data' do
      let(:user) { users(:no_collaborators) }
      let(:table) { datasets(:default_table) }

      it 'checks for permissions' do
        mock(Authorization::Authority).authorize! :explore_data, table.data_source, user, { :or => [:data_source_is_shared, :data_source_account_exists] }
        get :index, :dataset_id => table.to_param
      end
    end
  end
end
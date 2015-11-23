require 'spec_helper'

describe DataSourceAccount do
  it_behaves_like "a permissioned model" do
    let(:gpdb_data_source) { FactoryGirl.build(:gpdb_data_source) }
    let(:account) { data_sources(:default).accounts.first }
    let!(:model) { account }
  end
end

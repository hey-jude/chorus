require 'spec_helper'

describe AssociatedDataset do
  let(:gpdb_table) { FactoryGirl.create(:gpdb_table) }
  let(:workspace) { workspaces(:public) }

  it_behaves_like "a permissioned model" do
    let!(:model) { FactoryGirl.create(:associated_dataset, :workspace => workspace, :dataset => gpdb_table) }
  end
end

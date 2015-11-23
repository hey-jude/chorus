require 'spec_helper'

describe Import, :greenplum_integration do

  pending("KT TODO rewrite this so it doesn't require interaction with a real Greenplum database")

  # let(:workspace) { workspaces(:real) }
  # let(:import) do
  #   WorkspaceImport.create({
  #                            :workspace => workspace,
  #                            :to_table => 'new_table1234',
  #                            :new_table => true,
  #                            :source_dataset => source_dataset,
  #                            :user => user
  #                          }, :without_protection => true)
  # end
  #
  # it_behaves_like "a permissioned model" do
  #   let!(:model) { import }
  # end
end
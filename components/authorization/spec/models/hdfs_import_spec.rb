require 'spec_helper'

describe HdfsImport do
  let(:import) { FactoryGirl.create(:hdfs_import, :hdfs_entry => hdfs_entries(:directory), :file_name => file_name) }

  it_behaves_like "a permissioned model" do
    let(:file_name) { 'scoping.csv' }
    let!(:model) { import }
  end
end

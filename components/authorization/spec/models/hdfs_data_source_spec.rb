require 'spec_helper'

describe HdfsDataSource do
  it_behaves_like "a permissioned model" do
    let!(:model) { hdfs_data_sources(:hadoop) }
  end
end

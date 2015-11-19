require "spec_helper"

describe HdfsEntry do
  it_behaves_like "a permissioned model" do
    let!(:model) { hdfs_entries(:hdfs_file) }
  end
end

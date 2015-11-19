require 'spec_helper'

describe GnipDataSource do
  it_behaves_like "a permissioned model" do
    let!(:model) { gnip_data_sources(:default) }
  end
end

require 'spec_helper'

describe DataSource do
  it_behaves_like "a permissioned model" do
    let!(:model) { data_sources(:oracle) }
  end
end
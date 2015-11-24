require 'spec_helper'

describe Dataset do
  it_behaves_like "a permissioned model" do
    let!(:model) { datasets(:default_table) }
  end
end
require 'spec_helper'

describe Tag do
  it_behaves_like "a permissioned model" do
    let!(:model) { Tag.create!(name: "scope") }
  end
end

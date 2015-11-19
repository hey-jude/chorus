require "spec_helper"

describe "Event types" do
  it_behaves_like "a permissioned model" do
    let!(:model) { Events::Base.create! }
  end
end

require "spec_helper"

describe Activity do
  it_behaves_like "a permissioned model" do
    let!(:model) { Activity.global.create!(:created_at => Time.current + 25) }
  end
end

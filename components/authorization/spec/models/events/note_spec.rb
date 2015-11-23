require "spec_helper"

describe Events::Note do
  it_behaves_like "a permissioned model" do
    let!(:model) { events(:note_on_dataset) }
  end
end

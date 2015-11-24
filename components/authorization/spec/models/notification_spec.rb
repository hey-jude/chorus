require "spec_helper"

describe Notification do
  it_behaves_like "a permissioned model" do
    let!(:model) { notifications(:notification1) }
  end
end

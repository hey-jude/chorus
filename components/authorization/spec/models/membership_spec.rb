require 'spec_helper'

describe Membership do
  it_behaves_like "a permissioned model" do
    let!(:model) { Membership.first }
  end
end

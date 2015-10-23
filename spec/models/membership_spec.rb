require 'spec_helper'

describe Membership do
  describe "validations" do
    it { should validate_presence_of :user }
    it { should validate_presence_of :workspace }
  end

  it_behaves_like "a permissioned model" do
    let!(:model) { Membership.first }
  end
end

require 'spec_helper'

describe ChorusScope do
  describe "associations" do
    it { should have_and_belong_to_many(:groups) }
    it { should have_many(:chorus_objects) }
  end
end
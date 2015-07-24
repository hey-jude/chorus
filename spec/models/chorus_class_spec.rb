require 'spec_helper'

describe ChorusClass do
 it { should have_many(:chorus_objects) }
 it { should have_many(:operations) }
 it { should have_many(:permissions) }

  describe "search_permission_tree" do
    it "should find the ancestor with the activity symbol set" do
      class ThisBase
      end
      class InheritedClass < ThisBase
      end

      base_class = ChorusClass.create(:name => ThisBase.to_s)
      inherited_class = ChorusClass.create(:name => InheritedClass.to_s)
      base_class.operations << Operation.create(:name => "find_me")
      inherited_class.operations << Operation.create(:name => "don't_stop_for_me")

      found_class = ChorusClass.search_permission_tree(InheritedClass, :find_me)
      expect(found_class).to eq(base_class)
    end
  end
end

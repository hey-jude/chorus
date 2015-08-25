require 'spec_helper'


# This is for testing basic Permissioner methods. To test behavior
# about classes that 'include' Permissioner, see
# spec/support/shared_behaviors/permissioner_behaviors.rb. When you add Permissioner to a model,
# add the corresponding it_behaves_like 'a model with permissions',
# it_behaves_like 'a model with object level roles', etc. to the model_spec.rb.
# Those specs will make sure that the model code matches the expectations of Permissioner
describe Permissioner do
  describe "user_in_scope?" do
    it "should return true if the user is in a scope" do
      user = users(:the_collaborator)
      scope = ChorusScope.first
      group = Group.first
      group.users << user
      scope.groups << group

      expect(Permissioner.user_in_scope?(user)).to be_true
    end

    it "should return false if the user isn't in a scope" do
      user = users(:the_collaborator)
      expect(Permissioner.user_in_scope?(user)).to be_false
    end
  end
end

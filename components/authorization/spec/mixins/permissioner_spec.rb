require 'spec_helper'


# This is for testing basic Authorization::Permissioner methods. To test behavior
# about classes that 'include' Authorization::Permissioner, see
# spec/support/shared_behaviors/permissioner_behaviors.rb. When you add Authorization::Permissioner to a model,
# add the corresponding it_behaves_like 'a model with permissions',
# it_behaves_like 'a model with object level roles', etc. to the model_spec.rb.
# Those specs will make sure that the model code matches the expectations of Authorization::Permissioner
describe Authorization::Permissioner do
end

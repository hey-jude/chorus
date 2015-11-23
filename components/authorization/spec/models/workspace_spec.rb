require 'spec_helper'
require 'timecop'

describe Workspace do
  it_behaves_like "a permissioned model" do
    let!(:model) { workspaces(:public) }
  end

  describe "validations" do
    it { should validate_with MemberCountValidator }
  end

  describe "create" do
    let(:owner) { users(:no_collaborators) }
    let(:workspace) { owner.owned_workspaces.create!(name: 'new workspace!') }

    it "assigns the owner role to the owner" do
      workspace.users_for_role(Role.find_by_name("Owner")).should include(owner)
    end

    it "assigns the contributor role to the owner" do
      workspace.users_for_role(Role.find_by_name("ProjectManager")).should include(owner)
    end
  end

  describe 'permissions_for' do
    it 'should have the correct permissions per user' do
      owner = users(:no_collaborators)
      private_workspace = workspaces(:private_with_no_collaborators)
      public_workspace = workspaces(:public_with_no_collaborators)
      member = users(:the_collaborator)
      private_workspace.members << member
      admin = users(:admin)
      anon = users(:owner)
      dev = FactoryGirl.create(:user, :developer => true)
      private_workspace.members << dev
      admin_dev = FactoryGirl.create(:user, :developer => true, :admin => true)
      private_workspace.members << admin_dev
      public_admin_dev_member = workspaces(:public)
      public_admin_dev_member.members << admin_dev

      [
          [private_workspace, owner, [:admin]],
          [private_workspace, member, [:read, :commenting, :update, :duplicate_chorus_view]],
          [private_workspace, admin, [:admin]],
          [private_workspace, anon, []],
          [public_workspace, anon, [:read, :commenting]],
          [private_workspace, dev, [:read, :commenting, :update, :duplicate_chorus_view, :create_workflow]],
          [public_workspace, dev, [:read, :commenting]],
          [private_workspace, admin_dev, [:admin, :create_workflow]],
          [public_workspace, admin_dev, [:admin]],
          [public_admin_dev_member, admin_dev, [:admin, :create_workflow]]
      ].each do |workspace, user, list|
        workspace.permissions_for(user).should == list
      end
    end
  end
end

require 'spec_helper'

describe WorkspaceMembersManager do
  let(:workspace) { workspaces(:public) }
  let(:owner) { workspace.owner }
  let(:other_user) { users(:admin) }
  let(:member) { users(:the_collaborator) }
  let(:manager) { WorkspaceMembersManager.new(workspace, { "ProjectManager" => [owner.id] }, owner) }
  let(:new_member_manager) { WorkspaceMembersManager.new(workspace, { "ProjectManager" => [other_user.id, owner.id] }, owner) }
  let(:contributor_role) { Role.find_by_name("ProjectManager") }

  describe '#update_membership' do
    it 'updates the membership' do
      expect {
        manager.update_membership
      }.to change(workspace.members, :count).to(1)
    end

    it 'adds members to the contributor role' do
      expect{
        manager.update_membership
      }.to change{ workspace.users_for_role(contributor_role).count }.to(1)
    end

    it 'removes members from the contributor role' do
      expect{
        WorkspaceMembersManager.new(workspace, { "Contributor" => [owner.id] }, owner).update_membership
      }.to change{ workspace.users_for_role(contributor_role).count }.by(-1)
    end

    context 'when a removed member owns jobs in this workspace' do
      let!(:job) { FactoryGirl.create(:job, :workspace => workspace, :owner => member) }
      let!(:other_workspace_job) { FactoryGirl.create(:job, :workspace => workspaces(:private), :owner => member) }

      it 'resets ownership of jobs in this workspace owned by any removed users' do
        expect {
          manager.update_membership
          job.reload
        }.to change(job, :owner).from(member).to(owner)
      end

      it 'does not reset ownership of jobs in other workspaces' do
        manager.update_membership
        other_workspace_job.reload.owner.should == member
      end
    end
  end
end

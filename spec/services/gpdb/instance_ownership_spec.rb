require "spec_helper"

describe Gpdb::InstanceOwnership do
  let!(:old_owner) { gpdb_instance.owner }
  let!(:owner_account) { gpdb_instance.owner_account }
  let!(:new_owner) { FactoryGirl.create(:user) }

  describe ".change_owner(instance, new_owner)" do
    let(:gpdb_instance) { FactoryGirl.create(:gpdb_instance, :shared => true) }
    before do
      stub(gpdb_instance).valid_db_credentials? { true }
    end

    it "creates a GreenplumInstanceChangedOwner event" do
      request_ownership_update
      event = Events::GreenplumInstanceChangedOwner.by(old_owner).last
      event.gpdb_instance.should == gpdb_instance
      event.new_owner.should == new_owner
    end

    context "with a shared gpdb instance" do
      it "switches ownership of gpdb instance and account" do
        request_ownership_update
        gpdb_instance.owner.should == new_owner
        owner_account.owner.should == new_owner
      end
    end

    context "with an unshared instance" do
      let(:gpdb_instance) { FactoryGirl.create(:gpdb_instance, :shared => false) }

      context "when switching to a user with an existing account" do
        before do
          FactoryGirl.build(:instance_account, :instance => gpdb_instance, :owner => new_owner).tap { |a| a.save(:validate => false)}
        end

        it "switches ownership of instance" do
          request_ownership_update
          gpdb_instance.owner.should == new_owner
        end

        it "keeps ownership of account" do
          request_ownership_update
          owner_account.owner.should == old_owner
        end
      end

      context "when switching to a user without an existing account" do
        it "complains" do
          expect {
            request_ownership_update
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  def request_ownership_update
    Gpdb::InstanceOwnership.change(old_owner, gpdb_instance, new_owner)
    gpdb_instance.reload
    owner_account.reload
  end
end

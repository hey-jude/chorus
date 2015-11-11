require 'spec_helper'

describe ChorusObject do
  describe "associations" do
    it { should belong_to(:chorus_class) }
    it { should have_and_belong_to_many(:chorus_scopes) }
    it { should belong_to(:owner) }
  end

  describe "referenced_object" do

    let (:some_object) { workspaces(:public) }

    it "should return the referenced object" do
      chorus_class = ChorusClass.find_by_name(some_object.class.name)
      chorus_object = ChorusObject.create(:chorus_class_id => chorus_class.id, :instance_id => some_object.id)

      expect(chorus_object.referenced_object).to eq(some_object)
    end
  end

  context "chorus_object_roles" do
    let(:role){ roles(:a_role) }
    let(:user){ users(:no_collaborators) }
    let(:different_user){ users(:admin) }
    let(:chorus_object) { ChorusObject.create!(:instance_id => 1, :chorus_class_id => 1, :chorus_scope_id => 1) }

    describe "add_user_to_object_role" do
      it "should create a ChorusObjectRole object" do
          expect{chorus_object.add_user_to_object_role(user, role)}.to change{ChorusObjectRole.count}.by(1)
      end

      it "shouldn't create duplicate ChorusObjectRole objects if add is called twice" do
        chorus_object.add_user_to_object_role(user, role)
        expect{chorus_object.add_user_to_object_role(user, role)}.not_to change{ChorusObjectRole.count}.by(1)
      end
    end

    describe "remove_user_from_object_role" do
      it "should remove the corresponding chorus_object_role from the ChorusObjectRole table" do
        chorus_object.add_user_to_object_role(user, role)
        expect{chorus_object.remove_user_from_object_role(user, role)}.to change{ChorusObjectRole.count}.by(-1)
      end

      it "should remove the corresponding chorus_object_role from the chorus_object_role associations" do
        chorus_object.add_user_to_object_role(user, role)
        expect{chorus_object.remove_user_from_object_role(user, role)}.to change{chorus_object.chorus_object_roles.count}.by(-1)
      end
    end

    describe "roles_for_user" do
      it "should return an association of Role objects given a User object" do
        chorus_object.add_user_to_object_role(user, role)
        expect(chorus_object.roles_for_user(user)).to eql([role])
      end

      it "should not return a role if the user has been removed from the object role" do
        chorus_object.add_user_to_object_role(user, role)
        chorus_object.remove_user_from_object_role(user, role)
        expect(chorus_object.roles_for_user(user)).to be_empty
      end
    end

    describe "users_for_role" do
      it "should return an association of User objects given a Role object" do
        chorus_object.add_user_to_object_role(user, role)
        expect(chorus_object.users_for_role(role)).to eql([user])
      end

      it "should not return a user if the user has been removed from the object role" do
        chorus_object.add_user_to_object_role(user, role)
        chorus_object.remove_user_from_object_role(user, role)
        expect(chorus_object.users_for_role(user)).to be_empty
      end

      it "should not return users with the same role on a different chorus_object" do
        chorus_object.add_user_to_object_role(user, role)
        chorus_object_2 = ChorusObject.create!(:instance_id => 2, :chorus_class_id => 1, :chorus_scope_id => 1)
        chorus_object_2.add_user_to_object_role(different_user, role)

        expect(chorus_object.users_for_role(role)).not_to include(different_user)
        expect(chorus_object_2.users_for_role(role)).not_to include(user)
      end
    end

    describe "deleting a chorus_object" do
      before :each do
        chorus_object.add_user_to_object_role(user, role)
        chorus_object_id = chorus_object.id
        chorus_object.destroy
        @referenced_chorus_object_roles = ChorusObjectRole.where(:chorus_object_id => chorus_object_id)
      end

      it "should remove all of the corresponding chorus_object_roles" do
        expect(@referenced_chorus_object_roles).to be_empty
      end

      it "shouldn't delete the user" do
        expect(user).to be_present
      end

      it "shoudnl't delete the role" do
        expect(role).to be_present
      end
    end
  end
end
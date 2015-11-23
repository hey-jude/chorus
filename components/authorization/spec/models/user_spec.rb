require 'spec_helper'

describe User do
  it_behaves_like "a permissioned model" do
    let!(:model) { users(:default) }
  end

  describe "defaults" do
    it "has the default role" do
      User.new.roles.should include(Role.find_by_name("Collaborator"))
      User.new.roles.should include(Role.find_by_name("User"))
    end

    it "doesn't duplicate roles when pulling record from database" do
      u = User.new(:username => "single_role")
      old_roles = u.roles
      u.save(:validate => false)

      u = User.find_by_username("single_role")
      new_roles = u.roles
      old_roles.sort.should eq(new_roles.sort)
    end
  end

  describe "validations" do
    let(:max_user_icon_size) { ChorusConfig.instance['file_sizes_mb']['user_icon'] }

    it { should validate_with DeveloperCountValidator }
    it { should validate_with AdminCountValidator }
    it { should validate_with UserCountValidator }
  end

  describe "associations" do
    it { should have_and_belong_to_many(:groups) }
    it { should have_and_belong_to_many(:roles) }
    it { should have_many(:chorus_object_roles) }
    it { should have_many(:object_roles).through(:chorus_object_roles) }

    let(:user) { users(:owner) }
    let(:admin) { users(:admin) }
    let(:role) { roles(:a_role) }

    it "should not allow the same role to be in .roles more than once" do
      user.roles << role
      expect {
        user.roles << role
      }.to_not change { user.roles.count }
    end

    it "should remove the AppManager role if Admin role is removed" do
      admin.roles.destroy(Role.find_by_name("Admin"))
      expect(admin.roles.find_by_name("ApplicationManager")).to be_nil
    end

    it "should remove the Admin role if the AppManager role is removed" do
      admin.roles.destroy(Role.find_by_name("ApplicationManager"))
      expect(admin.roles.find_by_name("Admin")).to be_nil
    end

    it "should add the Admin role if the AppManager role is added" do
      admin_role = Role.find_by_name("Admin")
      user.roles << admin_role
      expect(user.roles).to include(Role.find_by_name("ApplicationManager"))
    end

    it "should add the AppManager role if the Admin role is added" do
      app_manager_role = Role.find_by_name("ApplicationManager")
      user.roles << app_manager_role
      expect(user.roles).to include(Role.find_by_name("Admin"))
    end
  end

  describe ".admin_count" do
    it "returns the number of admins that exist" do
      User.admin_count.should == User.where(:admin => true).count
    end
  end

  describe "#admin=" do
    let(:admin) { users(:admin) }
    let(:user) { users(:owner) }

    it "allows an admin to remove their own privileges, if there are other admins" do
      admin.admin = false
      admin.save!
      admin.reload
      admin.should_not be_admin
    end

    it "does not allow an admin to remove their own privileges if there are no other admins" do
      users(:evil_admin).delete
      admin.admin = false
      admin.save!
      admin.reload
      admin.should be_admin
    end

    it "should add the user to the ApplicationManager role" do
      user.admin = false
      user.admin = true
      user.save!
      user.reload
      user.roles.should include(Role.find_by_name("ApplicationManager"))
    end

    it "should remove the user f rom the ApplicationManager role" do
      admin.admin = false
      admin.save!
      admin.reload
      admin.roles.should_not include(Role.find_by_name("ApplicationManager"))
    end

    it "should create an admin if passed the string 'true'" do
      user.admin = false
      user.admin = "true"
      user.save!
      expect(user.admin?).to be_true
    end
  end

  describe '.developer_count' do
    it 'returns the number of developers that exist' do
      User.developer_count.should == User.where(:developer => true).count
    end
  end
end


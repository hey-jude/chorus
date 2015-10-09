require 'spec_helper'

describe Role do
  describe "associations" do
    it { should have_many(:permissions) }
    it { should have_and_belong_to_many(:users) }
    it { should have_and_belong_to_many(:groups) }
    it { should have_many(:chorus_objects).through(:chorus_object_roles) }

    let (:user) { users(:admin) }
    let (:role) { roles(:a_role) }
    it "should not allow dupliacte users" do
      role.users << user
      expect{ role.users << user }.to_not change{ role.users.count }.from(1).to(2)
    end

  end
end

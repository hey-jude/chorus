require File.dirname(__FILE__) + '/../spec_helper'


describe Authority do
  context "handle legacy permissions" do
    let(:user) { users(:default) }
    it "allows collaborators to view hdfs data sources" do
      object = hdfs_data_sources(:hadoop)
      user.roles << Role.find_by_name("Collaborator")
      expect(Authority.handle_legacy_action({:or => :data_source_account_exists }, object, user, ) ).to be_true
    end
  end
end
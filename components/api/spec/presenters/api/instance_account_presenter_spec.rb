require 'spec_helper'

describe Api::DataSourceAccountPresenter, :type => :view do
  before do
    @user = FactoryGirl.create :user

    @gpdb_data_source = FactoryGirl.create :gpdb_data_source
    @gpdb_data_source.owner = @user

    @account = FactoryGirl.build(:data_source_account).tap { |a| a.save(:validate => false)}
    @account.owner = @user
    @account.data_source = @gpdb_data_source

    @presenter = Api::DataSourceAccountPresenter.new(@account, view)
  end

  describe "#to_hash" do
    before do
      @hash = @presenter.to_hash
    end

    it "includes the right keys and values" do
      @hash[:id].should == @account.id
      @hash[:owner_id].should == @user.id
      @hash[:data_source_id].should == @gpdb_data_source.id
      @hash[:db_username].should == @account[:db_username]
    end

    it "should use ownerPresenter Hash method for owner" do
      @owner = @hash[:owner]
      @owner.to_hash.should == (Api::UserPresenter.new(@user, view).presentation_hash)
    end
  end
end
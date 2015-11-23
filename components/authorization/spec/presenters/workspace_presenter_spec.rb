require 'spec_helper'

describe Api::WorkspacePresenter, :type => :view do
  let(:user) { users(:owner) }
  let(:archiver) { users(:the_collaborator) }
  let(:schema) { schemas(:default) }
  let(:workspace) { FactoryGirl.build :workspace, :owner => user, :archiver => archiver, :sandbox => schema }
  let(:presenter) { Api::WorkspacePresenter.new(workspace, view, options) }

  before(:each) do
    Thread.current[:user] = user
  end

  let(:options) { {:permissions => [:admin]} }

  describe "#to_hash" do
    let(:hash) { presenter.to_hash }

    it "should respond with the current user's permissions (as an owner of the workspace)'" do
      hash[:permission].should == [:admin]
    end
  end
end
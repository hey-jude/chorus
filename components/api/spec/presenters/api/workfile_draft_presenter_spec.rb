require "spec_helper"

describe Api::WorkfileDraftPresenter, :type => :view do
  let(:draft) { FactoryGirl.create(:workfile_draft) }

  describe "#to_hash" do
    subject { Api::WorkfileDraftPresenter.new(draft, view).to_hash }

    it "includes the right attributes" do
      subject[:content].should == "Excellent content"
      subject[:id].should == draft.id
      subject[:workfile_id].should == draft.workfile.id
      subject[:owner_id].should == draft.owner.id
    end
  end
end

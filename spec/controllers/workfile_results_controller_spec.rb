require 'spec_helper'

describe WorkfileResultsController do
  describe "#create" do
    let(:user) { users(:admin) }
    let(:workfile) { workfiles(:alpine_flow) }
    let(:params) do
      {
        :workfile_id => workfile.id,
        :results_written => 'true'
      }
    end

    before do
      log_in user
    end

    it "should make a WorkfileResult event" do
      expect {
        post :create, params
      }.to change(Events::WorkfileResult, :count).by(1)
    end

    it "should return a 201" do
      post :create, params
      response.status.should == 201
    end

    context "when there is a result_id" do
      let(:params) do
        {
          :workfile_id => workfile.id,
          :results_written => 'true',
          :result_id => "123"
        }
      end

      it "creates an attachment for the WorkfileResult event" do
        expect{
          expect {
            post :create, params
          }.to change(Events::WorkfileResult, :count).by(1)
        }.to change(NotesWorkFlowResult, :count).by(1)

        NotesWorkFlowResult.last.result_id.should == "123"
        response.should be_success
      end
    end
  end
end
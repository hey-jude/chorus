require 'spec_helper'

describe Api::InsightsController do
  routes { Api::Engine.routes }

  describe "#publish (POST to /publish)" do
    before do
      log_in user
      note.insight = true;
      note.save!
    end

    let(:user) { note.actor }
    let(:note) { Events::NoteOnWorkspace.last }
    let(:note_id) { note.id }
    let(:post_params) { { :note => { :note_id => note_id } } }

    context 'when the note is private' do
      let(:note) { events(:note_on_no_collaborators_private_workfile) }

      context 'when the user does not have access' do
        let(:user) { users(:not_a_member) }

        it "returns permission denied status code" do
          post :publish, post_params

          response.code.should == '404'
        end
      end

      context "when the user is admin" do
        let(:user) { users(:admin) }

        it "returns status 201" do
          post :publish, post_params
          response.code.should == "201"
        end
      end

    end
  end
end
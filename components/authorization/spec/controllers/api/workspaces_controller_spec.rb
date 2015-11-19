require 'spec_helper'

describe Api::WorkspacesController do
  routes { Api::Engine.routes }

  render_views

  let(:owner) { users(:no_collaborators) }

  before do
    log_in owner
  end

  describe "#show" do
    let(:owner) { users(:owner) }
    let(:other_user) { users(:the_collaborator) }
    let(:workspace) { workspaces(:public) }

    context "with a valid workspace id" do
      it "uses authentication" do
        mock(Authority).authorize!.with_any_args
        get :show, :id => workspace.to_param
      end

      it "has the update permission if the user is a member" do
        log_in other_user

        m = Membership.new
        m.user = other_user
        m.workspace = workspace
        m.save

        get :show, :id => workspace.to_param
        response.decoded_body["response"]["permission"].should include("update")
      end
    end
  end
end
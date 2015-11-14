require "spec_helper"

describe Api::WorkspaceImagesController do
  routes { Api::Engine.routes }

  before do
    @user = users(:owner)
    log_in @user
    any_instance_of(Workspace) do |workspace|
      stub(workspace).save_attached_files { true }
    end
  end

  describe "#create" do
    context "for Workspace" do
      let(:workspace) { workspaces(:public) }
      let(:files) { [Rack::Test::UploadedFile.new(File.expand_path("spec/fixtures/small1.gif", ENV['CHORUS_HOME']), "image/gif")] }

      it "adds the workspace's image" do
        default_image_path = "/images/original/missing.png"
        workspace.image.url.should == ""
        post :create, :workspace_id => workspace.id, :files => files
        workspace.reload
        workspace.image.url.should_not == default_image_path
      end

      it "responds with the urls of the new image" do
        post :create, :workspace_id => workspace.id, :files => files
        workspace.reload
        response.code.should == "200"
        decoded_response.original.should == workspace.image.url(:original)
        decoded_response.icon.should == workspace.image.url(:icon)
      end

      it "authorizes on owner (or admin)" do
        log_in users(:not_a_member)
        post :create, :workspace_id => workspace.id, :files => files
        response.should be_forbidden
      end
    end
  end

  describe "#show" do
    let(:workspace) { workspaces(:image) }

    it "responds with the urls of the image" do
      mock(controller).send_file(workspace.image.path('original'), :type => workspace.image_content_type) {
        controller.head :ok
      }
      log_in workspace.owner
      get :show, :workspace_id => workspace.id
    end

    it "uses authorization" do
      mock(Authority).authorize!.with_any_args
      get :show, :workspace_id => workspace.id
    end
  end
end

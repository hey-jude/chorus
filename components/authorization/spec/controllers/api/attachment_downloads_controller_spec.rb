require 'spec_helper'

describe Api::AttachmentDownloadsController do
  routes { Api::Engine.routes }

  let(:user) { users(:default) }

  before do
    log_in user
  end

  describe "#show" do
    context "when the user doesn't have permission" do
      let(:attachment) { attachments(:attachment_private_workspace) }

      it 'returns 403' do
        get :show, :attachment_id => attachment.to_param
        response.should be_forbidden
      end
    end

  end
end

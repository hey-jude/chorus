require 'spec_helper'

describe Attachment do
  it_behaves_like "a permissioned model" do
    let!(:model) { attachments(:attachment_workspace) }
  end
end
require 'spec_helper'

describe Upload do
  it_behaves_like "a permissioned model" do
    let!(:model) { Upload.first }
  end
end

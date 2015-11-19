require "spec_helper"

describe WorkfileVersion do
  let!(:workfile) { workfile = FactoryGirl.create(:chorus_workfile) }
  let!(:version) { version = FactoryGirl.create(:workfile_version, :workfile => workfile) }

  it_behaves_like "a permissioned model" do
    let!(:model) { version }
  end
end

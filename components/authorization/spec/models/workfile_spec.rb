require 'spec_helper'

describe Workfile do
  it_behaves_like "a permissioned model" do
    let!(:model) { workfiles(:public) }
  end
end

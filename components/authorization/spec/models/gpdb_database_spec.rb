require 'spec_helper'

describe GpdbDatabase do
  it_behaves_like "a permissioned model" do
    let!(:model) { databases(:default) }
  end
end

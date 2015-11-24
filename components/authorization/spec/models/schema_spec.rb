require 'spec_helper'

describe Schema do
  let(:schema) { schemas(:public) }

  it_behaves_like "a permissioned model" do
    let!(:model) { schema }
  end
end
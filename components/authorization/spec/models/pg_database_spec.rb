require 'spec_helper'

describe PgDatabase do
  it_behaves_like "a permissioned model" do
    let!(:model) { databases(:pg) }
  end
end

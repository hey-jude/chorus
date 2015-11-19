require 'spec_helper'

describe CsvFile do
  it_behaves_like "a permissioned model" do
    let!(:model) { csv_files(:default) }
  end
end

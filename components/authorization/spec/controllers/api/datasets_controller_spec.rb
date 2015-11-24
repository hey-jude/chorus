require 'spec_helper'

describe Api::DatasetsController do
  routes { Api::Engine.routes }
  let(:user) { users(:not_a_member) }

  before do
    log_in user
  end

  describe "#show" do
    context "when dataset is valid in GPDB" do
      context "when the user does not have permission" do
        let(:table) { datasets(:default_table) }

        it "should return forbidden" do
          get :show, :id => table.to_param
          response.code.should == "403"
        end
      end
    end
  end
end
require 'spec_helper'
require 'timecop'

describe ApplicationController do

  describe "#require_admin" do
    controller do
      before_filter :require_admin

      def index
        head :ok
      end
    end

    before do
      log_in user
    end

    context "when user has no admin rights" do
      let(:user) { users(:no_collaborators) }

      it "returns error 403" do
        get :index
        response.should be_forbidden
      end
    end

    context "when user has admin rights" do
      let(:user) { users(:admin) }

      it "returns success" do
        get :index
        response.should be_ok
      end
    end
  end
end

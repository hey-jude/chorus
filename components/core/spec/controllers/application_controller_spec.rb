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

  describe "#current_user" do
    controller do
      def index
        render :text => current_user.present? ? current_user.id : nil
      end
    end

    let(:user) { users(:no_collaborators) }

    context 'the user is logged in' do
      before do
        log_in user
      end

      it "returns the user based on the session's user id" do
        get :index
        response.body.should == user.id.to_s
      end

      it 'returns nil when sent an invalid session_id param (csrf bypass attempt)' do
        get :index, :session_id => 'invalid'
        response.body.should == ' '
      end

      it 'returns nil when sent an empty session_id param (csrf bypass attempt)' do
        get :index, :session_id => ''
        response.body.should == ' '
      end
    end

    it "returns nil when there is no session_id stored in the session" do
      session[:chorus_session_id] = nil
      get :index
      response.body.should == ' '
    end

    it "returns nil when there is no session with the session_id" do
      session[:chorus_session_id] = -1
      get :index
      response.body.should == ' '
    end

    it "sets the user when session_id is sent" do
      session_object = Session.new
      session_object.user = user
      session_object.save(:validate => false)
      get :index, :session_id => session_object.session_id
      response.body.should == user.id.to_s
    end

    it "does not set the user when session_id is blank" do
      get :index, :session_id => ''
      response.body.should == ' '
    end
  end

end

require 'spec_helper'

describe Api::UsersController do
  routes { Api::Engine.routes }

  let(:user) { FactoryGirl.create(:user) }

  before do
    log_in user
  end

  describe "#index" do
    it_behaves_like "an action that requires authentication", :get, :index
  end

  describe "#create" do
    let(:params) {
      {
        :username => "another_user", :password => "secret", :first_name => "joe",
        :last_name => "user", :email => "joe@chorus.com", :title => "Data Scientist",
        :dept => "bureau of bureaucracy", :notes => "poor personal hygiene", :admin => true,
        :developer => true
      }
    }

    it_behaves_like "an action that requires authentication", :post, :create

    context "when creator is not admin" do
      let(:user) { FactoryGirl.create(:user) }

      it "should refuse" do
        post :create, params
        response.should be_forbidden
      end
    end

    context "when creator is admin" do
      let(:user) { FactoryGirl.create(:admin) }

      it "should succeed" do
        post :create, params
        response.code.should == "201"
      end

      it "should create a user" do
        post :create, params
        User.find_by_username(params[:username]).should be_present
      end

      it "should make a user an admin" do
        post :create, params
        User.find_by_username(params[:username]).admin.should be_true
        User.find_by_username(params[:username]).roles.should include('admin')
      end

      it "should set the admin role if the admin flag is a string" do
        params[:admin] = "true"
        post :create, params
        User.find_by_username(params[:username]).roles.should include('admin')
      end
    end
  end

  describe "#update" do
    let(:other_user) { FactoryGirl.create(:user, :first_name => 'other-user') }
    let(:admin) { FactoryGirl.create(:admin) }
    let(:non_admin) { FactoryGirl.create(:user, :first_name => 'non-admin') }

    it_behaves_like "an action that requires authentication", :put, :update, :id => '-1'

    context "when logged in as an admin" do
      before do
        log_in admin
      end

      context "with a valid user id" do
        it "responds with the updated user" do
          put :update, :id => other_user.to_param, :admin => true
          response.code.should == "200"
          decoded_response.admin.should == true
        end

        context 'changing admin status' do
          it "allows making someone an admin" do
            put :update, :id => other_user.to_param, :admin => true
            other_user.reload.should be_admin
          end

          it "allows an admin to remove their own privileges, if there are other admins" do
            put :update, :id => admin.to_param, :admin => false
            response.code.should == "200"
            decoded_response.admin.should == false
          end

          it "does not allow an admin to remove their own privileges if there are no other admins" do
            # assert User.admins.count == 1
            put :update, :id => admin.to_param, :admin => false
            response.code.should == "200"
            decoded_response.admin.should == true
          end

          context 'when the admin owns a job in a workspace of which they are not a member' do
            let(:workspace) { FactoryGirl.create(:workspace) }
            before do
              FactoryGirl.create(:job, :owner => admin, :workspace => workspace)
            end

            context 'removing their admin status' do
              it 'should transfer job ownership to the workspace owner' do
                job = Job.last
                expect {
                  put :update, :id => admin.to_param, :admin => false
                  job.reload
                }.to change(job, :owner).from(admin).to(workspace.owner)
              end
            end
          end

          context 'when the admin owns a job in a workspace of which they are a member' do
            let(:workspace) { FactoryGirl.create(:workspace) }
            before do
              FactoryGirl.create(:job, :owner => admin, :workspace => workspace)
              workspace.members << admin
            end

            context 'removing their admin status' do
              it 'should not transfer job ownership to the workspace owner' do
                job = Job.last
                expect {
                  put :update, :id => admin.to_param, :admin => false
                }.not_to change(job, :owner)
              end
            end
          end
        end

        it 'allows making someone a developer' do
          expect {
            put :update, :id => other_user.to_param, :developer => true
          }.to change { other_user.reload.developer? }.from(false).to(true)
          response.code.should == '200'
        end

        it "updates other attributes" do
          put :update, :id => other_user.to_param, :first_name => "updated"
          decoded_response.first_name.should == "updated"
        end
      end

      context "with an invalid user id" do
        it "returns not found" do
          put :update, :id => 'bogus', :first_name => "updated"
          response.should be_not_found
        end
      end
    end

    context "when the current user is not an admin" do
      before do
        log_in non_admin
      end

      it "allows the user to edit their own profile" do
        expect {
          put :update, :id => non_admin.to_param, :first_name => "updated"
        }.to_not change { non_admin.reload.last_name }

        decoded_response.first_name.should == "updated"
      end

      it "does not allow non-admins to make themselves an admin" do
        put :update, :id => non_admin.to_param, :admin => true
        non_admin.reload.should_not be_admin
      end

      it "does not allow non-admins to update other users" do
        expect {
          put :update, :id => other_user.to_param, :first_name => "updated"
        }.to_not change { other_user.reload.first_name }
        response.code.should == "403"
      end

      it 'does not allow non-admins to make themselves a developer' do
        expect {
          put :update, :id => other_user.to_param, :developer => true
        }.to_not change { other_user.reload.developer? }
      end

      it "lets users change their own password" do
        put :update, :id => non_admin.to_param, :password => '987654'
        response.code.should == "200"
        user = User.find(non_admin.to_param)
        user.password_digest.should == Digest::SHA256.hexdigest("987654" + user.password_salt)
      end
    end
  end

  describe "#show" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user, :first_name => 'other-user') }
    before do
      log_in user
    end

    it_behaves_like "an action that requires authentication", :get, :show, :id => '-1'

    context "with a valid user id" do
      it "succeeds" do
        get :show, :id => other_user.to_param
        response.should be_success
      end

      it "presents the user" do
        mock.proxy(controller).present(other_user)
        get :show, :id => other_user.to_param
      end
    end

    context "with an invalid user id" do
      it "returns not found" do
        get :show, :id => 'bogus'
        response.should be_not_found
      end
    end

  end

  describe "#destroy" do
    context "admin" do
      before do
        log_in FactoryGirl.create(:admin)
      end

      context "user with no data sources or workspaces" do
        let(:user) { FactoryGirl.create(:user, :first_name => 'the-collaborator') }

        before do
          delete :destroy, :id => user.id
        end

        it "should succeed" do
          response.code.should == "200"
        end

        it "should respond with valid json" do
          lambda { JSON.parse(response.body) }.should_not raise_error
        end

        it "should delete the user" do
          deleted_user = User.find_with_destroyed(user.id)
          deleted_user.deleted_at.should_not be_nil
        end
      end

      context "user owns an data source" do
        let(:user) { FactoryGirl.create(:user, :first_name => 'the-collaborator') }

        before do
          user.gpdb_data_sources << FactoryGirl.create(:data_source)
          delete :destroy, :id => user.id
        end

        it "should fail" do
          response.code.should == "422"
        end

        it "should not delete the user" do
          live_user = User.find_with_destroyed(user.id)
          live_user.deleted_at.should be_nil
        end
      end

      context "user owns a workspace" do
        let(:user) { FactoryGirl.create(:user, :first_name => 'the-collaborator') }

        before do
          workspace = FactoryGirl.create(:workspace, :owner => user)
          # assert workspace.persisted? == true
          # user.owned_workspaces << workspace
          # assert user.owned_workspaces.count > 0
          delete :destroy, :id => user.id
        end

        it "should fail" do
          response.code.should == "422"
        end

        it "should not delete the user" do
          live_user = User.find_with_destroyed(user.id)
          live_user.deleted_at.should be_nil
        end
      end
    end

    context "non-admin" do
      let(:user) { FactoryGirl.create(:user, :first_name => 'the-collaborator') }

      before(:each) do
        log_in FactoryGirl.create(:user, :first_name => 'owner')
        delete :destroy, :id => user.id
      end

      it "should not succeed" do
        response.code.should == "403"
      end

      it "should not delete the user" do
        live_user = User.find_with_destroyed(user.id)
        live_user.deleted_at.should be_nil
      end
    end

    context "admin trying to delete himself" do
      let(:admin) { FactoryGirl.create(:admin) }

      before do
        log_in admin
        delete :destroy, :id => admin.id
      end

      it "should not succeed" do
        response.code.should == "403"
      end
    end
  end

  describe "#ldap" do
    before do
      @user_attributes = {:username => "testguy", :first_name => "Test", :last_name => "Guy", :title => "Big Kahuna", :dept => "Greenery", :email => "testguy@example.com"}
      stub(LdapClient).search.with_any_args { [@user_attributes] }
    end

    it_behaves_like "an action that requires authentication", :get, :ldap

    context "as an admin" do
      before(:each) do
        log_in FactoryGirl.create(:admin)
      end

      it "returns the set of matching users" do
        get :ldap, :username => "foo"
        response.should be_success
        hash = response.decoded_body[:response].first
        @user_attributes.keys.each do |key|
          hash[key].should == @user_attributes[key]
        end
      end

    end

    context "as a non-admin" do
      before(:each) do
        log_in FactoryGirl.create(:user, :first_name => 'owner')
      end

      it "returns unauthorized" do
        get :ldap, :username => "foo"
        response.code.should == "403"
      end
    end
  end
end

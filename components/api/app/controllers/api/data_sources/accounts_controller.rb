# KT TODO why not inherit from DataSourcesController?
module Api::DataSources
  class AccountsController < ApiController
    before_filter :check_source_disabled?

    def show
      present DataSource.find(params[:data_source_id]).account_for_user(current_user)
    end

    def create
      present updated_account, :status => :created
    end

    def update
      present updated_account, :status => :ok
    end

    def destroy
      data_source = DataSource.unshared.find(params[:data_source_id])
      data_source.account_for_user(current_user).destroy
      render :json => {}
    end

    private

    def updated_account
      data_source = DataSource.find(params[:data_source_id])

      account = data_source.account_for_user(current_user) || data_source.accounts.build(:owner => current_user)

      Authority.authorize! :edit_credentials, data_source, current_user, { :or => :current_user_is_account_owner }
      account.attributes = params[:account]

      Authority.authorize! :edit_credentials, data_source, current_user, { :or => :current_user_is_account_owner }

      account.save!
      account
    end

    def check_source_disabled?
      ::DataSourcesController.render_forbidden_if_disabled(params)
    end
  end
end

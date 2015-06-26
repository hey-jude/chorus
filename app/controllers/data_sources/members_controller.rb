module DataSources
  class MembersController < ApplicationController
    wrap_parameters :account, :include => [:db_username, :db_password, :owner_id]

    def index
      accounts = DataSource.find(params[:data_source_id]).accounts
      accounts = DataSourceAccount.filter_by_scope(current_user, accounts) if current_user_in_scope?

      present paginate(accounts.includes(:owner).order(:id))
    end

    def create
      data_source = DataSource.unshared.find(params[:data_source_id])
      Authority.authorize! :update, data_source, current_user, { :or => :current_user_is_object_owner }

      account = data_source.accounts.find_or_initialize_by_owner_id(params[:account][:owner_id])
      account.attributes = params[:account]

      account.save!

      present account, :status => :created
    end

    def update
      gpdb_data_source = DataSource.find(params[:data_source_id])
      Authority.authorize! :update, gpdb_data_source, current_user, { :or => :current_user_is_object_owner }

      account = gpdb_data_source.accounts.find(params[:id])
      account.attributes = params[:account]
      account.save!

      present account, :status => :ok
    end

    def destroy
      gpdb_data_source = DataSource.find(params[:data_source_id])
      Authority.authorize! :update, gpdb_data_source, current_user, { :or => :current_user_is_object_owner }
      account = gpdb_data_source.accounts.find(params[:id])

      account.destroy
      render :json => {}
    end
  end
end

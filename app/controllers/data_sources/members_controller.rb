module DataSources
  class MembersController < ApplicationController
    wrap_parameters :account, :include => [:db_username, :db_password, :owner_id]

    def index
      accounts = DataSource.find(params[:data_source_id]).accounts.includes(:owner).order(:id)
      accounts = DataSourceAccount.filter_by_scope(current_user, accounts) if current_user_in_scope?

      present paginate(accounts)
    end

    def create
      gpdb_data_source = DataSource.unshared.find(params[:data_source_id])
      Authority.authorize! :update, gpdb_data_source, current_user, { :or => :current_user_is_object_owner }

      owner = User.find(params[:account][:owner_id])
      account = gpdb_data_source.accounts.find_or_initialize_by(owner: owner)

      account.attributes = params[:account]

      account.save!

      # Need to clean workspace cache for user so that dashboard displays correct no of data sources. DEV-9092
      if gpdb_data_source.instance_of?(GpdbDataSource)
        user = account.owner
        workspaces = gpdb_data_source.workspaces
        workspaces.each do |workspace|
          if workspace.members.include? user
            workspace.delete_cache(user)
          end
        end
      end

      present account, :status => :created
    end

    def update
      gpdb_data_source = DataSource.find(params[:data_source_id])
      Authority.authorize! :update, gpdb_data_source, current_user, { :or => :current_user_is_object_owner }

      account = gpdb_data_source.accounts.find(params[:id])
      account.attributes = params[:account]
      account.save!

      # Need to clean workspace cache for user so that dashboard displays correct no of data sources. DEV-9092
      if gpdb_data_source.instance_of?(GpdbDataSource)
        user = account.owner
        workspaces = gpdb_data_source.workspaces
        workspaces.each do |workspace|
          if workspace.members.include? user
            workspace.delete_cache(user)
          end
        end
      end

      present account, :status => :ok
    end

    def destroy
      gpdb_data_source = DataSource.find(params[:data_source_id])
      Authority.authorize! :update, gpdb_data_source, current_user, { :or => :current_user_is_object_owner }
      account = gpdb_data_source.accounts.find(params[:id])

      # Need to clean workspace cache for user so that dashboard displays correct no of data sources. DEV-9092
      if gpdb_data_source.instance_of?(GpdbDataSource)
        user = account.owner
        workspaces = gpdb_data_source.workspaces
        workspaces.each do |workspace|
          if workspace.members.include? user
            workspace.delete_cache(user)
          end
        end
      end

      account.destroy
      render :json => {}
    end
  end
end

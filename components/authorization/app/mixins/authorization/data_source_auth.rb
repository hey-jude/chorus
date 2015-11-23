module DataSourceAuth
  extend ActiveSupport::Concern

  def authorize_data_source_access(resource)
    Authorization::Authority.authorize! :explore_data,
                         resource.data_source,
                         current_user,
                         { :or => [:data_source_is_shared, :data_source_account_exists] }
  end

  def authorize_data_sources_access(resource)
    resource.data_sources.each do |data_source|
      Authorization::Authority.authorize! :explore_data,
                           data_source,
                           current_user,
                           { :or => [:data_source_is_shared, :data_source_account_exists] }
    end
  end

  def authorized_account(resource)
    authorize_data_source_access(resource)
    account_for_current_user(resource)
  end

  def account_for_current_user(resource)
    if resource.data_source.respond_to? :account_for_user!
      resource.data_source.account_for_user!(current_user)
    end
  end
end

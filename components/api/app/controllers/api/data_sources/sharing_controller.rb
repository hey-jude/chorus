# KT TODO why not inherit from DataSourcesController?
module Api::DataSources
  class SharingController < ApiController
    before_filter :check_source_disabled?

    def create
      Authorization::Authority.authorize! :update, data_source, current_user, { :or => :current_user_is_object_owner }

      data_source.shared = true
      data_source.accounts.where("id != #{data_source.owner_account.id}").destroy_all
      data_source.save!
      present data_source, :status => :created
    end

    def destroy
      Authorization::Authority.authorize! :update, data_source, current_user, { :or => :current_user_is_object_owner }

      data_source.shared = false
      data_source.save!
      present data_source
    end

    private

    def data_source
      @data_source ||= DataSource.find(params[:data_source_id])
    end

    def check_source_disabled?
      Api::DataSourcesController.render_forbidden_if_disabled(params)
    end
  end
end
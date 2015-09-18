require 'will_paginate/array'

module Api
  class WorkletsController < ApiController
    wrap_parameters :workfile
    include DataSourceAuth

    before_filter :authorize_show_worklet, :only => [:show]
    before_filter :authorize_edit_worklet, :only => [:update, :destroy, :upload_image]

    def show

      if params[:connect].present?
        authorize_data_sources_access worklet
        worklet.attempt_data_source_connection
      end

      #log_workfile_opened_event(worklet, current_user)

      present worklet, :presenter_options => {:contents => true, :workfile_as_latest_version => true}
    end

    def create
      #   authorize! :can_edit_sub_objects, workspace

      merged_params = ActiveSupport::HashWithIndifferentAccess['file_name', params[:workfile][:file_name]]
                        .merge(params[:workfile])
                        .merge(:workspace => workspace, :owner => current_user, :content_type => 'worklet')
                        .merge(:workflow_id => params[:workfile][:workflow_id])
                        .merge(:state => 'completed')

      # merge_params should have content_type = 'worklet'
      workfile = Worklet.build_for(merged_params)
      workfile.update_from_params!(merged_params)
      if !params[:workfile][:parameters].nil?
        JSON.parse(params[:workfile][:parameters]).each do |parameters|
          worklet_variable = WorkletParameter.new(parameters.merge('workfile_id' => workfile.id))
          worklet_variable.save!
        end
      end

      present workfile,
              presenter_options: {:workfile_as_latest_version => true},
              status: :created
    end

    def update
      worklet.assign_attributes(params[:workfile])
      worklet.update_from_params!(params[:workfile])

      if existing_published_worklets.any?
        update_publish_params = {}
        update_publish_params[:file_name] = worklet.file_name
        update_publish_params[:description] = worklet.description
        update_publish_params[:run_persona] = worklet.run_persona
        update_publish_params[:output_table] = worklet.output_table
        existing_published_worklets[0].assign_attributes(update_publish_params)
        existing_published_worklets[0].update_from_params!(update_publish_params)
      end

      present worklet,
              :presenter_options => {:workfile_as_latest_version => true}
    end

    def image
      worklet_image = worklet.worklet_image
      if worklet_image.present?
        send_file worklet_image.path(:display), disposition: 'inline'
      else
        send_data GeoPattern.generate(worklet.id, generator: GeoPattern::HexagonPattern), type: 'image/svg+xml', disposition: 'inline'
      end
    end

    def upload_image
      worklet.image = params[:contents]
      worklet.save!
      present worklet.worklet_image
    end

    def destroy
      worklet.destroy
      render :json => {}
    end

    def authorize_show_worklet
      Authority.authorize! :show,
                           worklet.workspace,
                           current_user,
                           {:or => [:current_user_is_in_workspace,
                                    :workspace_is_public]}
    end

    def authorize_edit_worklet
      Authority.authorize! :update, worklet.workspace, current_user, {:or => :can_edit_sub_objects}
    end

    def publish
      published_param = {:state => 'published'}
      worklet.assign_attributes(published_param)
      worklet.update_from_params!(published_param)

      if existing_published_worklets.any?
        existing_published_worklets[0].assign_attributes(published_param)
        existing_published_worklets[0].update_from_params!(published_param)
      else
        published_worklet_params = ActiveSupport::HashWithIndifferentAccess['file_name', worklet.file_name]
        published_worklet_params.merge!(:source_worklet_id => worklet.id, :owner => current_user, :description => worklet.description)
        published_worklet_params.merge!(:file_name => worklet.file_name, :content_type => 'published_worklet', :workspace => Workspace.find(worklet.workspace_id), :entity_subtype => 'published_worklet')
        published_worklet_params.merge!(published_param)
        published_worklet_params.merge!(:workflow_id => worklet.workflow_id, :run_persona => worklet.run_persona, :output_table => worklet.output_table, :state => worklet.state)
        published_worklet = PublishedWorklet.build_for(published_worklet_params)
        published_worklet.update_from_params!(published_worklet_params)
      end

      Events::WorkletPublished.by(current_user).add(:workfile => worklet, :workspace => Workspace.find(worklet.workspace_id))

      present worklet, :status => :accepted
    end

    def unpublish
      if existing_published_worklets.any? && RunningWorkfile.where(:workfile_id => existing_published_worklets[0].id).any?
        render_cannot_unpublish
      else

        unpublished_param = {:state => 'completed'}
        worklet.assign_attributes(unpublished_param)
        worklet.update_from_params!(unpublished_param)

        if existing_published_worklets.any?
          existing_published_worklets[0].assign_attributes(unpublished_param)
          existing_published_worklets[0].update_from_params!(unpublished_param)
          Events::WorkletUnpublished.by(current_user).add(:workfile => worklet, :workspace => Workspace.find(worklet.workspace_id))
        end

        present worklet, :status => :accepted
      end
    end

    def run
      begin
        worklet_params = params[:workfile][:worklet_parameters][:string].inspect

        temp_accounts = []

        worklet.execution_locations.each do |execution_location|
          if execution_location.is_a?(Database)
            data_source = execution_location.data_source
            if !(data_source.shared? || DataSourceAccount.where(:data_source_id => data_source.id, :owner_id => current_user.id).any?)
              data_source_account = DataSourceAccount.where(:data_source_id => execution_location.data_source.id, :owner_id => worklet.owner_id)
              if worklet.run_persona == 'creator' && data_source_account.any?
                temp_data_source_account = data_source_account[0].dup
                temp_data_source_account.owner_id = current_user.id
                temp_data_source_account.save!
                temp_accounts.push(temp_data_source_account)
              else
                Authority.raise_access_denied(:run, execution_location)
              end
            end
          end
        end

        process_id = worklet.run_now(current_user, worklet_params)
        test_run = params[:workfile][:test_run]
        running_workfile = RunningWorkfile.new({:workfile_id => params[:id], :owner_id => current_user.id, :killable_id => process_id, :status => test_run ? 'test_run' : ''})
        running_workfile.save!
        if params[:workfile][:worklet_parameters][:fields] && !test_run
          params[:workfile][:worklet_parameters][:fields].each do |field|
            worklet_parameter_version = WorkletParameterVersion.new({:worklet_parameter_id => field['id'], :value => field['value'], :owner_id => current_user.id, :result_id => process_id})
            worklet_parameter_version.save!
          end
        end

        present worklet, :status => :accepted
      rescue Authority::AccessDenied
        render_no_db_access
      rescue Alpine::API::RunError
        render_run_failed
      ensure
        temp_accounts.each do |temp_account|
          temp_account.destroy
        end
      end
    end

    def stop
      response = worklet.stop_now(current_user)
      RunningWorkfile.where(:owner_id => current_user.id, :workfile_id => params[:workfile][:id]).destroy_all if response.code == '200'
      present worklet, :status => :accepted
    end

    def worklet
      @worklet ||= Worklet.find(params[:id])
    end

    def existing_published_worklets
      @existing_published_worklets ||= PublishedWorklet.where("additional_data SIMILAR TO '%(,|{)\"source_worklet_id\":#{ worklet.id.to_s }(,|})%'")
    end

    def workspace
      @workspace ||= Workspace.find(params[:workspace_id])
    end

    def render_no_db_access
      present_errors({:record => :RUN_NO_DB_ACCESS}, :status => :unprocessable_entity)
    end

    def render_run_failed
      present_errors({:record => :RUN_FAILED}, :status => :unprocessable_entity)
    end

    def render_cannot_unpublish
      present_errors({:record => :CANNOT_UNPUBLISH}, :status => :unprocessable_entity)
    end

  end
end
require 'will_paginate/array'

class PublishedWorkletController < ApplicationController
  wrap_parameters :workfile
  include DataSourceAuth

  #before_filter :convert_form_encoded_arrays, :only => [:create, :update]
  #before_filter :authorize_edit_workfile, :only => [:update, :destroy,  :run, :stop]

  def index
    published_worklets = PublishedWorklet.where("additional_data LIKE '%\"state\":\"published\"%'")

    published_worklets = published_worklets.order_by(params[:order]).includes(:latest_workfile_version)
    published_worklets = published_worklets.where("workfiles.file_name ILIKE ?", "%#{params[:name_pattern]}%") if params[:name_pattern]

    present paginate(published_worklets), :presenter_options => {:cached => true, :namespace => "published_worklets"}
  end

  def show
    #authorize! :show, worklet.workspace
    if worklet.state != 'published'
      Authority.raise_access_denied(:show, worklet)
    end

    present worklet, :presenter_options => {:contents => true, :workfile_as_latest_version => true}
  end

  def worklet
    @worklet ||= Worklet.find(params[:id])
  end

  def run
    begin
      #worklet_params = params[:workfile][:worklet_parameters][:string].inspect
      params_obj = {}
      params[:workfile][:worklet_parameters][:fields].each do |field|
        params_obj[field[:name]] = field[:value]
      end
      worklet_params = params_obj.inspect

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

  def share
    Events::WorkletResultShared.by(current_user).add(
        :workfile => worklet,
        :workspace => Workspace.find(params[:workspace_id]),
        :result_note_id => params[:results_id]
    )
    present Workspace.find(params[:workspace_id]), :status => :accepted
  end

  def render_no_db_access
    present_errors({:record => :RUN_NO_DB_ACCESS}, :status => :unprocessable_entity)
  end

  def render_run_failed
    present_errors({:record => :RUN_FAILED}, :status => :unprocessable_entity)
  end

end

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

    present worklet, :presenter_options => {:contents => true, :workfile_as_latest_version => true}
  end

  def worklet
    @worklet ||= Worklet.find(params[:id])
  end

  def run
    worklet_params = params[:workfile][:worklet_parameters][:string].inspect
    process_id = worklet.run_now(current_user, worklet_params)
    test_run = params[:workfile][:test_run]
    running_workfile = RunningWorkfile.new({:workfile_id => params[:id], :owner_id => current_user.id, :killable_id => process_id, :status => test_run ? 'test_run' : ''})
    running_workfile.save!
    if !test_run
      params[:workfile][:worklet_parameters][:fields].each do |field|
        worklet_parameter_version = WorkletParameterVersion.new({:worklet_parameter_id => field['id'], :value => field['value'], :owner_id => current_user.id, :result_id => process_id})
        worklet_parameter_version.save!
      end
    end
    present worklet, :status => :accepted
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
    present worklet, :status => :accepted
  end

end

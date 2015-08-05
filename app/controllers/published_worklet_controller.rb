require 'will_paginate/array'

class PublishedWorkletController < ApplicationController
  wrap_parameters :workfile
  include DataSourceAuth

  #before_filter :convert_form_encoded_arrays, :only => [:create, :update]
  #before_filter :authorize_edit_workfile, :only => [:update, :destroy,  :run, :stop]

  def index
    published_worklets = PublishedWorklet.where("additional_data LIKE '%\"state\":\"published\"%'").order(:id)

    present published_worklets
  end

  def show
    #authorize! :show, worklet.workspace

    present worklet, :presenter_options => {:contents => true, :workfile_as_latest_version => true}
  end

  def worklet
    @worklet ||= Worklet.find(params[:id])
  end

  def variables

  end

  def run
    variables = params[:workfile][:worklet_parameters][:string].inspect
    process_id = worklet.run_now(current_user, variables)
    running_workfile = RunningWorkfile.new({:workfile_id => params[:id], :owner_id => current_user.id, :killable_id => process_id})
    running_workfile.save!
    params[:workfile][:worklet_parameters][:fields].each do |field|
      worklet_variable_version = WorkletVariableVersion.new({:worklet_variable_id => field['id'], :value => field['value'], :owner_id => current_user.id, :result_id => process_id})
      worklet_variable_version.save!
    end
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

require 'will_paginate/array'

class WorkletsController < ApplicationController
  wrap_parameters :workfile
  include DataSourceAuth

  def show
    #authorize! :show, worklet.workspace

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

    present worklet,
            :presenter_options => {:workfile_as_latest_version => true}
  end

  def image
    send_data GeoPattern.generate(worklet.id, generator: GeoPattern::HexagonPattern), type: 'image/svg+xml', disposition: 'inline'
  end

  def destroy
    worklet.destroy
    render :json => {}
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
      published_worklet_params.merge!(:file_name => worklet.file_name, :content_type => 'published_worklet', :workspace => Workspace.find(worklet.workspace_id), :entity_subtype =>'published_worklet' )
      published_worklet_params.merge!(published_param)
      published_worklet_params.merge!(:workflow_id => worklet.workflow_id, :run_persona => worklet.run_persona, :output_table => worklet.output_table, :state => worklet.state)
      published_worklet = PublishedWorklet.build_for(published_worklet_params)
      published_worklet.update_from_params!(published_worklet_params)
    end

    Events::WorkletPublished.by(current_user).add(:workfile => worklet, :workspace => Workspace.find(worklet.workspace_id))

    present worklet, :status => :accepted
  end

  def unpublish
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

  def run
    worklet_params = params[:workfile][:worklet_parameters][:string].inspect
    process_id = worklet.run_now(current_user, worklet_params)
    running_workfile = RunningWorkfile.new({:workfile_id => params[:id], :owner_id => current_user.id, :killable_id => process_id})
    running_workfile.save!
    params[:workfile][:worklet_parameters][:fields].each do |field|
      worklet_parameter_version = WorkletParameterVersion.new({:worklet_parameter_id => field['id'], :value => field['value'], :owner_id => current_user.id, :result_id => process_id})
      worklet_parameter_version.save!
    end

    present worklet, :status => :accepted
  end

  def worklet
    @worklet ||= Worklet.find(params[:id])
  end

  def existing_published_worklets
    @existing_published_worklets ||= PublishedWorklet.where("additional_data LIKE '%\"source_worklet_id\":" + worklet.id.to_s + "%'")
  end

  def workspace
    @workspace ||= Workspace.find(params[:workspace_id])
  end
end

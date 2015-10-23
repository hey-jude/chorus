class WorkfileResultsController < ApplicationController
  def create
    if params[:results_written] == 'true' && !test_run
      event = workfile.create_result_event(params[:result_id])
      present event, :status => :created
    else
      render :json => {}
    end
  end

  def test_run
    running_workfile = RunningWorkfile.where_with_destroyed(:owner_id => current_user.id, :workfile_id => workfile.id, :killable_id => params[:result_id])
    workfile.is_a?(Worklet) && running_workfile.any? && running_workfile[0].status == 'test_run'
  end

  def workfile
    @workfile ||= Workfile.find(params[:workfile_id])
  end
end
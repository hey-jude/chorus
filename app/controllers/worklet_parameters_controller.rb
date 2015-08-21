class WorkletParametersController < ApplicationController
  def index
    #worklet = Worklet.find(params[:worklet_id])
    #present worklet.variables

    worklet_parameters = WorkletParameter.where(:workfile_id => params[:worklet_id])
    present worklet_parameters
  end

  def show
    #worklet = Worklet.find(params[:worklet_id])
    #worklet_parameter = worklet.parameters.find(params[:id])

    worklet_parameter = WorkletParameter.find(params[:id])
    present worklet_parameter
  end

  def update
    #worklet = Worklet.find(params[:worklet_id])

    # Authority.authorize! :edit, worklet_variable, current_user
    worklet_parameter = WorkletParameter.find(params[:id])
    worklet_parameter.update_attributes!(params[:worklet_parameter])

    present worklet_parameter
  end

  def create
    worklet_parameter = WorkletParameter.new(params[:worklet_parameter].merge('workfile_id' => params[:worklet_id]))
    worklet_parameter.save!

    present worklet_parameter, :status => :created
  end

  def destroy
    worklet_parameter = WorkletParameter.find(params[:id])

    #Authority.authorize! :destroy, worklet_variable, current_user
    worklet_parameter.destroy

    head :ok
  end
end

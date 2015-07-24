class WorkletVariablesController < ApplicationController
  def index
    #worklet = Worklet.find(params[:worklet_id])
    #present worklet.variables

    worklet_variables = WorkletVariable.where(:workfile_id => params[:worklet_id])
    present worklet_variables
  end

  def show
    #worklet = Worklet.find(params[:worklet_id])
    #worklet_variable = worklet.variables.find(params[:id])

    worklet_variable = WorkletVariable.find(params[:id])
    present worklet_variable
  end

  def update
    #worklet = Worklet.find(params[:worklet_id])
    #authorize! :edit, worklet

    worklet_variable = WorkletVariable.find(params[:id])
    worklet_variable.update_attributes!(params[:worklet_variable])

    present worklet_variable
  end

  def create
    worklet_variable = WorkletVariable.new(params[:worklet_variable].merge('workfile_id' => params[:worklet_id]))
    worklet_variable.save!

    present worklet_variable
  end
end

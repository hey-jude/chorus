class WorkletVariableVersionsController < ApplicationController

  def index
    worklet_variable_versions = WorkletVariableVersion.where(:event_id => params[:event_id])
    present worklet_variable_versions
  end

  def show
    present WorkletVariableVersion.find(params[:id])
  end
end

class WorkletParameterVersionsController < ApplicationController

  def index
    worklet_parameter_versions = WorkletParameterVersion.where(:event_id => params[:event_id])
    present worklet_parameter_versions
  end

  def show
    present WorkletParameterVersion.find(params[:id])
  end
end

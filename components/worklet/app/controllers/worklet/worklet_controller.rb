require_dependency "worklet/application_controller"

module Worklet
  class WorkletController < ApplicationController
    layout 'worklet/application'

    respond_to :html, :js, :json

    def index
      @content_id = params[:content_id]
      @menu_id = params[:menu_id]

      respond_with()

    end

    def list
      @content_id = params[:content_id]
      @menu_id = params[:menu_id]

      respond_with()

    end

  end
end
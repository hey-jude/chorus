module Api
  class ChorusViewsController < ApiController
    wrap_parameters :chorus_view, :exclude => [:id]
    before_filter :find_chorus_view, :only => [:update, :destroy, :convert, :duplicate]
    before_filter :authorize, :only => [:update, :destroy, :convert]

    def create
      chorus_view = ChorusView.new(params[:chorus_view])

      Authorization::Authority.authorize! :update, chorus_view.workspace, current_user, {:or => :can_edit_sub_objects}

      if (params[:chorus_view][:source_object_type] == 'workfile')
        source_object = Workfile.find(params[:chorus_view][:source_object_id])
      else
        source_object = Dataset.find(params[:chorus_view][:source_object_id])
      end

      ChorusView.transaction do
        chorus_view.save!
        Events::ChorusViewCreated.by(current_user).add(
          :workspace => chorus_view.workspace,
          :source_object => source_object,
          :dataset => chorus_view
        )
      end

      present chorus_view, :status => :created
    end

    def duplicate
      old_chorus_view = @chorus_view
      chorus_view = old_chorus_view.create_duplicate_chorus_view(params[:chorus_view][:object_name])

      Authorization::Authority.authorize! :update, chorus_view.workspace, current_user, {:or => :can_edit_sub_objects}

      ChorusView.transaction do
        chorus_view.save!

        Events::ChorusViewCreated.by(current_user).add(
          :workspace => chorus_view.workspace,
          :source_object => old_chorus_view,
          :dataset => chorus_view
        )
      end
      present chorus_view, :presenter_options => {:workspace => chorus_view.workspace}, :status => :created
    end

    def update
      ChorusView.transaction do
        @chorus_view.update_attributes!(params[:chorus_view])

        Events::ChorusViewChanged.by(current_user).add(
          :workspace => @chorus_view.workspace,
          :dataset => @chorus_view
        )
      end
      present @chorus_view
    end

    def destroy
      @chorus_view.destroy

      render :json => {}
    end

    def convert

      database_view = @chorus_view.convert_to_database_view(params[:object_name], current_user)
      Events::ViewCreated.by(current_user).add(
        :workspace => @chorus_view.workspace,
        :dataset => database_view,
        :source_dataset => @chorus_view
      )
      render :json => {}, :status => :created
    end

    private

    def find_chorus_view
      @chorus_view = ChorusView.find(params[:id])
    end

    def authorize
      Authorization::Authority.authorize! :update, @chorus_view.workspace, current_user, {:or => :can_edit_sub_objects}
    end

  end
end
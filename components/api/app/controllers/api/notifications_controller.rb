module Api
  class NotificationsController < ApiController
    def index
      notifications = current_user.notifications.order("created_at DESC").
        includes(:event => Events::Base.activity_stream_eager_load_associations).
        includes(:recipient, :comment)
      notifications = notifications.unread if params['type'] == 'unread'
      # PT:SCOPE Filter results by scope for current user

      if notifications.count != 0
        notifications = Notification.filter_by_scope(current_user, notifications) if current_user_in_scope?
      end

      present paginate(notifications), :presenter_options => {:activity_stream => true, :succinct => true, :cached => true, :namespace => "notifications"}
    end

    def read
      current_user.notifications.where(:id => params[:notification_ids]).update_all(:read => true)
      head :ok
    end

    def destroy
      notification = Notification.find(params[:id])
      Authorization::Authority.authorize! :destroy, notification, current_user, {:or => :current_user_is_object_recipient}
      notification.destroy
      render :json => {}
    end
  end
end
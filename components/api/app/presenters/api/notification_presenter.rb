module Api
  class NotificationPresenter < ApiPresenter
    def to_hash
      event_presenter = Api::EventPresenter.new(model.event, @view_context, options)
      {
        :id => model.id,
        :recipient => present(model.recipient, options),
        :event => event_presenter.simple_hash,
        :comment => present(model.comment, options),
        :unread => !(model.read),
        :timestamp => model.created_at
      }
    end

    def complete_json?
      true
    end
  end
end
module Api
  class SessionPresenter < ApiPresenter

    def to_hash
      {
        :session_id => model.session_id,
        :user => present(model.user, options)
      }
    end

    def complete_json?
      true
    end
  end
end
module Api
  class DashboardPresenter < ApiPresenter
    def to_hash
      {
        :entity_type => model.entity_type,
        :data => data
      }
    end

    private

    def data
      model.result
    end
  end
end

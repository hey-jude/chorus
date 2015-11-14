module Api
  class DashboardConfigPresenter < ApiPresenter

    def to_hash
      modules = model.dashboard_items

      {
        :user_id => model.user.id,
        :modules => modules,
        :available_modules => DashboardItem::ALLOWED_MODULES - modules
      }
    end
  end
end
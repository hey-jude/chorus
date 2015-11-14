module Dashboard
  class SiteSnapshot < DataModule

    attr_reader :user

    INCREMENT_TIME = 7.days.ago

    private

    def fetch_results

      if @user == nil
        [Workspace, AssociatedDataset, Workfile, User].map do |model|
          {
              :model => model.to_s.underscore,
              :total => model.count,
              :increment => changed_count(model)
          }
        end
      else
        [Workspace, AssociatedDataset, Workfile, User].map do |model|
          {
              :model => model.to_s.underscore,
              # Fix for DEV-12309.  Turning off scope filter until 5.7
              #:total => model.count_in_scope(@user),
              :total => model.count,
              :increment => changed_count(model)
          }
        end
      end
    end

    private

    def changed_count(model)
      count_created = model.where('"created_at" > ?', INCREMENT_TIME).count
      count_deleted = model.unscoped.where('"created_at" < ? AND "deleted_at" > ?', INCREMENT_TIME, INCREMENT_TIME).count
      count_created - count_deleted
    end
  end
end

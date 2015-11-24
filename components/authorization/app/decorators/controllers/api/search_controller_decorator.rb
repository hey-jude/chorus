Api::SearchController.class_eval do
  before_filter :require_admin, :only => [:reindex]
end
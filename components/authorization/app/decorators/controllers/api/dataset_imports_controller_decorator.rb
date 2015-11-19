Api::DatasetImportsController.class_eval do
  before_filter :require_admin, :only => :update
end
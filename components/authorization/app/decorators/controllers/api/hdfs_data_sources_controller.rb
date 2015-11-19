Api::HdfsDataSourcesController.class_eval do
  before_filter :require_data_source_create, :only => [:create]
end
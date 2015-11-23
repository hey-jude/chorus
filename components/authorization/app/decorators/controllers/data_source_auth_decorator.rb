[Api::AnalyzeController,
 Api::ColumnsController,
 Api::DataSourcesController,
 Api::DatabaseSchemasController,
 Api::DatabasesController,
 Api::DatasetDownloadsController,
 Api::DatasetsController,
 Api::ExternalTablesController,
 Api::FunctionsController,
 Api::PreviewsController,
 Api::PublishedWorkletController,
 Api::SchemasController,
 Api::StatisticsController,
 Api::WorkfilesController,
 Api::WorkletsController,
 Api::WorkspaceDatasetsController
].each do |clazz|
  clazz.class_eval do
    include Authorization::DataSourceAuth
  end
end
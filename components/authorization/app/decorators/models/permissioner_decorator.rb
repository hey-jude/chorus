%w( Activity
    AssociatedDataset
    Attachment
    CsvFile
    Database
    Dataset
    DataSource
    DataSourceAccount
    Events::Base
    Events::Note
    GnipDataSource
    HdfsDataSource
    HdfsEntry
    HdfsImport
    Import
    Job
    JobTask
    Membership
    Milestone
    Notification
    OpenWorkfileEvent
    Schema
    Tag
    Upload
    Workfile
    WorkfileVersion).each do |s|
  s.constantize.class_eval do
    include Permissioner
  end
end

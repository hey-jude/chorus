class AssociatedDatasetPresenter < Presenter
  delegate :id, :workspace, :gpdb_database_object, :to => :model

  def to_hash
    {
      :workspace => present(workspace)
    }.merge(present(gpdb_database_object))
  end
end

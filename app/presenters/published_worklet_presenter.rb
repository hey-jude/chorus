class PublishedWorkletPresenter < WorkletPresenter
  def variables
    model.published_variables
  end
end
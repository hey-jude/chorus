class PublishedWorkletPresenter < WorkletPresenter
  def parameters
    model.published_parameters
  end
end
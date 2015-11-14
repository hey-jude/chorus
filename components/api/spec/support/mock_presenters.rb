module MockPresenters
  def mock_present(&block)
    mock(ApiPresenter).present.with_any_args(&block)
  end
end

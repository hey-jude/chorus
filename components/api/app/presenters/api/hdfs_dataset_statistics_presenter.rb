module Api
  class HdfsDatasetStatisticsPresenter < ApiPresenter
    def to_hash
      {:file_mask => model.file_mask}
    end

    def complete_json?
      true
    end
  end
end
module Api
  class AnalyzeController < ApiController

    def create
      dataset = Dataset.find(params[:table_id])
      dataset.analyze(authorized_account(dataset))
      present([], :status => :ok)
    end
  end
end
module Api
  class ColumnsController < ApiController

    def index
      dataset = Dataset.find(params[:dataset_id])
      present paginate DatasetColumn.columns_for(authorized_account(dataset), dataset)
    end
  end
end
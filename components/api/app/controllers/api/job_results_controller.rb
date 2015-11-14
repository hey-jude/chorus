module Api
  class JobResultsController < ApiController
    def show
      job = Job.find(params[:job_id])
      present job.job_results.last
    end
  end
end
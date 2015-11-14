module Api
  class LicensesController < ApiController
    def show
      present License.instance
    end
  end
end
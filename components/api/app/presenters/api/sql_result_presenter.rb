module Api
  class SqlResultPresenter < ApiPresenter
    def to_hash
      {
        :columns => present(model.columns),
        :rows => model.rows,
        :warnings => model.warnings
      }
    end

    def complete_json?
      true
    end
  end
end
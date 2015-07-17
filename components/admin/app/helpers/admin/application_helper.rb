module Admin
  module ApplicationHelper
    def get_row_class(index)
      return index.even? ?  "even" : "odd"
    end
  end
end

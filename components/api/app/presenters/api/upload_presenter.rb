module Api
  class UploadPresenter < ApiPresenter

    def to_hash
      {
        :id => model.id,
        :file_name => model.contents_file_name
      }
    end

  end
end
module Api
  class ImagePresenter < ApiPresenter

    def to_hash
      {
        :original => model.url(:original),
        :icon => model.url(:icon),
        :entity_type => 'image'
      }
    end

    def complete_json?
      true
    end
  end
end

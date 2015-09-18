module Api
  class TagPresenter < ApiPresenter
    def to_hash
      {
        :id => model.id,
        :name => model.name,
        :count => model.taggings_count,
        :entity_type => 'tag'
      }
    end
  end
end
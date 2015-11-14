require 'set'

class PublishedWorklet < Worklet

  has_additional_data :source_worklet_id

  before_validation { self.content_type ='published_worklet' }

  def entity_subtype
    'published_worklet'
  end

  def worklet_image
    Worklet.find(self.source_worklet_id).image
  end

  def published_parameters
    WorkletParameter.where(:workfile_id => self.source_worklet_id)
  end

end
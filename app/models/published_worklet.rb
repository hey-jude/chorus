require 'set'

class PublishedWorklet < Worklet

  has_additional_data :source_worklet_id

  before_validation { self.content_type ='published_worklet' }

  def entity_subtype
    'published_worklet'
  end

  def published_variables
    WorkletVariable.where(:workfile_id => self.source_worklet_id)
  end

end
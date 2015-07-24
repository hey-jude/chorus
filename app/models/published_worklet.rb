require 'set'

class PublishedWorklet < Worklet

  has_additional_data :source_worklet_id

  validates_uniqueness_of :file_name, :scope => [:workspace_id, :deleted_at, :content_type], if: :is_published_worklet
  before_validation { self.content_type ='published_worklet' }

  def is_published_worklet
    self.content_type == 'published_worklet'
  end

  def entity_subtype
    'published_worklet'
  end

  def published_variables
    WorkletVariable.where(:workfile_id => self.source_worklet_id)
  end

end
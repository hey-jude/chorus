require 'set'

class Worklet < AlpineWorkfile
  attr_accessible :content_type, :additional_data, :as => :create
  has_additional_data :workflow_id, :run_persona, :output_table, :state

  has_many :variables, :foreign_key => :workfile_id, :class_name => 'WorkletVariable'

  attr_accessible :worklet_image
  has_attached_file :worklet_image, :styles => { :icon => "50x50>" },
                    :path => ":rails_root/system/:class/:id/:style/:basename.:extension",
                    :url => "/:class/:id/worklet_image?style=:style",
                    :default_url => "/images/worklet_images/default.png"
  validates_attachment_content_type :worklet_image, :content_type => /\Aimage\/.*\Z/

  before_validation { self.content_type ='worklet' }

  def run_now(user, variables)
    process_id = Alpine::API.run_worklet(self, user, variables)
    update_attributes(status: RUNNING, killable_id: process_id) unless process_id.empty?
    process_id
  end

  def destroy

    if self.state == 'published'
      errors.add(:workfile, :published_worklet_associated)
      raise ActiveRecord::RecordInvalid.new(self)
    end

    published_worklet = PublishedWorklet.where("additional_data LIKE '%\"source_worklet_id\":" + self.id.to_s + "%'")
    if published_worklet.count > 0
      published_worklet.destroy_all
    end

    super
  end

  def entity_subtype
    'worklet'
  end

  def create_result_event(result_id)
    event = super
    RunningWorkfile.where(:owner_id => current_user.id, :workfile_id => self.id).destroy_all
    WorkletVariableVersion.where(:result_id => result_id).update_all(:event_id => event.id)
    event
  end

  def self.published_entries
    where('additional_data like \'%"state":"published"%\'')
  end

end
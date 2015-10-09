require 'set'

class Worklet < AlpineWorkfile
  attr_accessible :content_type, :additional_data, :as => :create
  has_additional_data :workflow_id, :run_persona, :output_table, :state

  has_many :parameters, :foreign_key => :workfile_id, :class_name => 'WorkletParameter'

  has_attached_file :image, :styles => {:display => "500x310>"},
                    :path => ":rails_root/system/worklets/:id/:style/:basename.:extension"
  #validates_attachment_content_type :worklet_image, :content_type => /\Aimage\/.*\Z/

  before_validation { self.content_type ='worklet' }

  def execution_locations
    WorkfileExecutionLocation.where(:workfile_id => self.workflow_id).map(&:execution_location)
  end

  def run_now(user, variables)
    process_id = Alpine::API.run_worklet(self, user, variables)
    update_attributes(status: RUNNING, killable_id: process_id) unless process_id.empty?
    process_id
  end

  def stop_now(user)
    running_workfile = RunningWorkfile.where(:owner_id => user.id, :workfile_id => self.id)
    if running_workfile.any?
      killable_id = running_workfile[0].killable_id
      response = Alpine::API.stop_worklet(self, killable_id, user)
      update_attribute(:status, IDLE) if response.code == '200'
      response
    else
      ''
    end
  end

  def destroy

    if self.state == 'published'
      errors.add(:workfile, :published_worklet_associated)
      raise ActiveRecord::RecordInvalid.new(self)
    end

    published_worklet = PublishedWorklet.where("additional_data SIMILAR TO '%(,|{)\"source_worklet_id\":#{ self.id.to_s }(,|})%'")
    if published_worklet.count > 0
      published_worklet.destroy_all
    end

    super
  end

  def worklet_image
    self.image
  end

  def entity_subtype
    'worklet'
  end

  def create_result_event(result_id)
    event = super
    event.output_table = self.output_table
    event.save!
    #RunningWorkfile.where(:owner_id => current_user.id, :workfile_id => self.id).destroy_all
    WorkletParameterVersion.where(:result_id => result_id).update_all(:event_id => event.id)
    event
  end

  def self.published_entries
    where('additional_data like \'%"state":"published"%\'')
  end

end
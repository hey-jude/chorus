class Activity < ActiveRecord::Base
  include Permissioner

  GLOBAL = "GLOBAL"

  attr_accessible :entity, :entity_type, :event
  belongs_to :entity, :polymorphic => true
  belongs_to :event, :class_name => 'Events::Base', :touch => true

  def self.global
    where(:entity_type => GLOBAL)
  end

  def self.remove_events_with_deleted_milestones(events)
    milestone_created_events = events.where(:action => Events::MilestoneCreated)
    milestone_created_events.each do |milestone_event|
      milestone = Milestone.find(milestone_event.target1_id) rescue nil
      if milestone.blank? && milestone_event.additional_data.blank?
        logger.debug "Rejected event =======> #{milestone_event.id}"
        events = events.reject {|e| e.id == milestone_event.id}
      end
    end
    return events
  end

end

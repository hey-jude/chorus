class Milestone < ActiveRecord::Base
  include Permissioner

  STATES = ['planned', 'achieved']

  belongs_to :workspace, :touch => true

  has_many :activities, :as => :entity
  has_many :events, :through => :activities
  has_many :comments, :through => :events

  has_many :most_recent_comments, -> { order('id DESC').limit(1) }, :through => :events, :source => :comments, :class_name => "Comment"

  attr_accessible :name, :state, :target_date

  validates_presence_of :name, :state, :target_date, :workspace
  validates_inclusion_of :state, :in => STATES

  after_save :project_hooks
  after_update :create_milestone_updated_event, :if => :current_user
  after_create :create_milestone_created_event, :if => :current_user
  after_destroy :project_hooks

  before_validation :set_state_planned, :on => :create


  private

  def project_hooks
    update_counter_cache
    update_workspace_target_date
  end

  def update_workspace_target_date
    workspace.reload
    date = workspace.milestones.any? ? workspace.milestones.order(:target_date).last.target_date : nil
    workspace.update_attribute(:project_target_date, date)
  end

  def update_counter_cache
    workspace.update_column(:milestones_count, workspace.milestones.count)
    workspace.update_column(:milestones_achieved_count, workspace.milestones.where(state: 'achieved').count)
  end

  def set_state_planned
    self.state = 'planned'
  end

  def create_milestone_updated_event
    Events::MilestoneUpdated.add(
      :actor => current_user,
      :milestone => self,
      :workspace => workspace
    )
  end

  def create_milestone_created_event
    Events::MilestoneCreated.add(
      :actor => current_user,
      :milestone => self,
      :workspace => workspace
    )
  end

end

class Group < ActiveRecord::Base
  attr_accessible :name, :description , :avatar

  validates :name, :presence => true, uniqueness: true

  has_and_belongs_to_many :chorus_scopes, -> { uniq }
  has_and_belongs_to_many :users, -> { uniq }
  has_and_belongs_to_many :roles, -> { uniq }

  # Delete HABTM association objects
  before_destroy {users.clear}
  before_destroy {roles.clear}

  has_attached_file :avatar, :path => ":rails_root/system/:class/:id/:style/:basename.:extension",
                    :url => "/:class/:id/image?style=:style",
                    :default_url => '/images/general/default-user.png', :styles => {:icon => "50x50>"}


  def move_members_to_another_team(new_team_id)
    new_group = Group.find(new_team_id)
    old_users = self.users
    if new_group
      old_users.map do |user|
        unless new_group.users.include?(user)
          new_group.users << user
        end
      end
    else
      return false
    end
  end
end
class Group < ActiveRecord::Base
  attr_accessible :name, :description , :avatar

  validates :name, :presence => true, uniqueness: true

  has_and_belongs_to_many :users, :uniq => true
  has_and_belongs_to_many :roles, :uniq => true

  # Delete HABTM association objects
  before_destroy {users.clear}
  before_destroy {roles.clear}

  has_one :chorus_scope


  has_attached_file :avatar, :path => ":rails_root/system/:class/:id/:style/:basename.:extension",
                    :url => "/:class/:id/image?style=:style",
                    :default_url => '/images/general/default-user.png', :styles => {:icon => "50x50>"}
end
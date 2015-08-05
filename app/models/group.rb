class Group < ActiveRecord::Base
  attr_accessible :name, :description

  validates :name, :presence => true, uniqueness: true

  has_and_belongs_to_many :users, :uniq => true
  has_and_belongs_to_many :roles, :uniq => true

  # Delete HABTM association objects
  before_destroy { |group| group.users.destroy_all }
  before_destroy { |group| group.roles.destroy_all }

  has_one :chorus_scope
end
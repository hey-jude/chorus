class Group < ActiveRecord::Base
  attr_accessible :name, :description

  validates :name, :presence => true, uniqueness: true

  has_and_belongs_to_many :users, -> { uniq }
  has_and_belongs_to_many :roles, -> { uniq }

  # Delete HABTM association objects
  before_destroy { users.clear }
  before_destroy { roles.clear }

  has_one :chorus_scope
end
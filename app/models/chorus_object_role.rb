class ChorusObjectRole < ActiveRecord::Base
  attr_accessible :user_id, :chorus_object_id, :role_id

  validates_uniqueness_of :user_id, :scope => [:chorus_object_id, :role_id]
  validates :role_id, :presence => true
  validates :chorus_object_id, :presence => true
  validates :user_id, :presence => true

  belongs_to :user
  belongs_to :chorus_object
  belongs_to :role
end
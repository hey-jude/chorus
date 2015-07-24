class Operation < ActiveRecord::Base
  attr_accessible :name, :description, :sequence

  validates :name, :presence => true
  validates_uniqueness_of :name, :scope => :chorus_class_id
  belongs_to :chorus_class

  validates :name, :presence => true
end

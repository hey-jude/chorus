class Operation < ActiveRecord::Base
  attr_accessible :name, :description, :sequence

  belongs_to :chorus_class

  validates :name, :presence => true
end

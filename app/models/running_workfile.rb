class RunningWorkfile < ActiveRecord::Base
  include SoftDelete
  include TaggableBehavior

  attr_accessible :workfile_id, :owner_id, :killable_id, :as => [:default, :create]
end
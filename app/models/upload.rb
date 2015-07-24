class Upload < ActiveRecord::Base
  include StaleUpload
  include Permissioner


  attr_accessible :contents

  belongs_to :user

  has_attached_file :contents, :path => ':rails_root/system/:class/:id/:basename.:extension'
  do_not_validate_attachment_file_type :contents

  validates :user, :presence => true
  validates :contents, :attachment_presence => true
  validates_attachment_size :contents,
                            :less_than => ChorusConfig.instance['file_sizes_mb']['hd_upload'].megabytes,
                            :message => :file_size_exceeded

end

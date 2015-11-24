require 'factory_girl'

FactoryGirl.define do

  factory :hdfs_import do
    user
    hdfs_entry
    upload
  end
end


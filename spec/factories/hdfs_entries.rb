require 'factory_girl'

FactoryGirl.define do

  factory :hdfs_entry do
    hdfs_data_source
    is_directory false
    path "/folder/subfolder/file.csv"
    modified_at 1.year.ago
  end

end


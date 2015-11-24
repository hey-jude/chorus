require 'factory_girl'

FactoryGirl.define do

  factory :hdfs_dataset_statistics do
    initialize_with do
      new({ 'file_mask' => 'A file mask' })
    end
  end

end
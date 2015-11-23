require 'factory_girl'

FactoryGirl.define do

  factory :hdfs_entry_statistics do
    owner { Faker::Name.first_name }
    group { Faker::Name.last_name }
    modified_at { Time.current.to_s }
    accessed_at { Time.current.to_s }
    size { rand(1..100000) }
    block_size { rand(1..10000) }
    permissions 'rwx--w--r'
    replication { rand(1..4) }
  end

end


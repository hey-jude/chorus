require 'factory_girl'

FactoryGirl.define do

  factory :gpdb_dataset_column do
    sequence(:name) { |n| "column#{n}" }
    data_type "text"
    description "A nice gpdb column description"
    sequence(:ordinal_position)
  end

  factory :oracle_dataset_column do
    sequence(:name) { |n| "column#{n}" }
    data_type "text"
    description "A nice oracle column description"
    sequence(:ordinal_position)
  end

end


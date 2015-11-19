require 'factory_girl'

FactoryGirl.define do

  factory :associated_dataset do
    association :dataset, :factory => :gpdb_table
    workspace
  end

end
require 'factory_girl'

FactoryGirl.define do

  factory :gpdb_database do
    sequence(:name) { |n| "database#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    association :data_source, :factory => :gpdb_data_source
  end

  factory :pg_database do
    sequence(:name) { |n| "pg_database#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    association :data_source, :factory => :pg_data_source
  end
end
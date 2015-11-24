require 'factory_girl'

FactoryGirl.define do

  factory :gpdb_schema do
    sequence(:name) { |n| "schema#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    association :database, :factory => :gpdb_database
    refreshed_at Time.current
  end

  factory :oracle_schema do
    sequence(:name) { |n| "oracle_schema#{n + FACTORY_GIRL_SEQUENCE_OFFSET}"}
    association :data_source, :factory => :oracle_data_source
  end

  factory :jdbc_schema do
    sequence(:name) { |n| "jdbc_schema#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    association :data_source, :factory => :jdbc_data_source
  end

  factory :pg_schema do
    sequence(:name) { |n| "pg_schema#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    association :database, :factory => :pg_database
  end

end
require 'factory_girl'

FactoryGirl.define do

  factory :chorus_view do
    sequence(:name) { |n| "chorus_view#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    association :schema, :factory => :gpdb_schema
    association :workspace
    query "select 1;"

    # Skip validations because, we cannot pass ChorusView#validate_query without a real connection ...
    to_create {|instance|
      instance.save(validate: false)
    }
  end

  factory :oracle_table do
    sequence(:name) { |n| "table#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    association :schema, :factory => :oracle_schema
  end

  factory :oracle_view do
    sequence(:name) { |n| "view#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    association :schema, :factory => :oracle_schema
  end

  factory :jdbc_table do
    sequence(:name) { |n| "table#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    association :schema, :factory => :jdbc_schema
  end

  factory :jdbc_view do
    sequence(:name) { |n| "view#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    association :schema, :factory => :jdbc_schema
  end

  factory :pg_table do
    sequence(:name) { |n| "table#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    association :schema, :factory => :pg_schema
  end

  factory :pg_view do
    sequence(:name) { |n| "view#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    association :schema, :factory => :pg_schema
  end

  factory :gpdb_table do
    sequence(:name) { |n| "table#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    association :schema, :factory => :gpdb_schema
  end

  factory :gpdb_view do
    sequence(:name) { |n| "view#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    association :schema, :factory => :gpdb_schema
  end

  factory :hdfs_dataset do
    sequence(:name) { |n| "#{Faker::Company.name}_#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    hdfs_data_source
    workspace
    file_mask "/*"
  end

end
require 'factory_girl'

FactoryGirl.define do

  factory :data_source do
    sequence(:name) { |n| "data_source#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    sequence(:host) { |n| "data_source#{n + FACTORY_GIRL_SEQUENCE_OFFSET}.emc.com" }
    sequence(:port) { |n| 5000+n }
    db_name "db_name"
    db_username "username"
    db_password "password"
    owner
  end

  factory :gpdb_data_source do
    sequence(:name) { |n| "gpdb_data_source#{n}" }
    sequence(:host) { |n| "gpdb_host#{n}.emc.com" }
    sequence(:port) { |n| 5000+n }
    db_name "postgres"
    owner
    version "9.1.2 - FactoryVersion"
    db_username 'username'
    db_password 'secret'
    after(:build) do |data_source|
      def data_source.valid_db_credentials?(account)
        true
      end
    end

    after(:create) do |data_source|
      data_source.singleton_class.send :remove_method, :valid_db_credentials?
    end
  end

  factory :oracle_data_source do
    sequence(:name) { |n| "oracle_data_source#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    sequence(:host) { |n| "oracle_host#{n + FACTORY_GIRL_SEQUENCE_OFFSET}.emc.com" }
    sequence(:port) { |n| 5000+n }
    db_name "db_name"
    owner
    db_username 'username'
    db_password 'secret'
    after(:build) do |data_source|
      def data_source.valid_db_credentials?(account)
        true
      end
    end

    after(:create) do |data_source|
      data_source.singleton_class.send :remove_method, :valid_db_credentials?
    end
  end

  factory :jdbc_data_source do
    sequence(:name) { |n| "jdbc_data_source#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    sequence(:host) { |n| "jdbc:teradata://jdbc_server#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    owner
    db_username 'username'
    db_password 'secret'
    after(:build) do |data_source|
      def data_source.valid_db_credentials?(account)
        true
      end
    end

    after(:create) do |data_source|
      data_source.singleton_class.send :remove_method, :valid_db_credentials?
    end
  end

  factory :pg_data_source, :class => PgDataSource do
    sequence(:name) { |n| "pg_data_source#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    sequence(:host) { |n| "pg_host#{n + FACTORY_GIRL_SEQUENCE_OFFSET}.my_postgres.com" }
    sequence(:port) { |n| 5000+n }
    db_name "postgres"
    owner
    version "9.1.2 - FactoryVersion"
    db_username 'username'
    db_password 'secret'
    after(:build) do |data_source|
      def data_source.valid_db_credentials?(account)
        true
      end
    end

    after(:create) do |data_source|
      data_source.singleton_class.send :remove_method, :valid_db_credentials?
    end
  end

  factory :hdfs_data_source do
    sequence(:name) { |n| "hdfs_data_source#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    sequence(:host) { |n| "host#{n + FACTORY_GIRL_SEQUENCE_OFFSET}.emc.com" }
    sequence(:port) { |n| 5000+n }
    sequence(:job_tracker_host) { |n| "job-tracker-host#{n + FACTORY_GIRL_SEQUENCE_OFFSET}.emc.com" }
    sequence(:job_tracker_port) { |n| 10000+n }
    hdfs_version "Pivotal HD 3"
    high_availability { false }
    owner
  end

  factory :gnip_data_source do
    sequence(:name) { |n| "gnip_data_source#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    sequence(:stream_url) { |n| "https://historical.gnip.com/stream_url#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    sequence(:username) { |n| "user#{n + FACTORY_GIRL_SEQUENCE_OFFSET}" }
    password "secret"
    owner
  end

end